# == Schema Information
#
# Table name: petitions
#
#  id                               :integer          not null, primary key
#  name                             :string(255)
#  subdomain                        :string(255)
#  description                      :text(65535)
#  initiators                       :text(65535)
#  statement                        :text(65535)
#  request                          :text(65535)
#  date_projected                   :date             default(NULL)
#  office_id                        :integer
#  organisation_id                  :integer
#  organisation_name                :string(255)
#  petitioner_organisation          :string(255)
#  petitioner_birth_date            :date
#  petitioner_birth_city            :string(255)
#  petitioner_name                  :string(255)
#  petitioner_address               :string(255)
#  petitioner_postalcode            :string(255)
#  petitioner_city                  :string(255)
#  petitioner_email                 :string(255)
#  petitioner_telephone             :string(255)
#  maps_query                       :string(255)
#  office_suggestion                :string(255)
#  organisation_kind                :string(255)
#  link1                            :string(255)
#  link2                            :string(255)
#  link3                            :string(255)
#  link1_text                       :string(255)
#  link2_text                       :string(255)
#  link3_text                       :string(255)
#  site1                            :string(255)
#  site1_text                       :string(255)
#  signatures_count                 :integer          default(0), not null
#  number_of_signatures_on_paper    :integer          default(0), not null
#  number_of_newsletters_sent       :integer          default(0), not null
#  created_at                       :datetime
#  updated_at                       :datetime
#  last_confirmed_at                :datetime
#  status                           :string(255)
#  manager_id                       :integer
#  show_twitter                     :boolean
#  show_history                     :boolean
#  show_map                         :boolean
#  twitter_query                    :string(255)
#  lat_lng                          :string(255)
#  lat_lng_sw                       :string(255)
#  lat_lng_ne                       :string(255)
#  special_count                    :integer          default(0), not null
#  display_more_information         :boolean
#  display_signature_person_citizen :boolean          default(FALSE)
#  display_signature_full_address   :boolean          default(FALSE)
#  archived                         :boolean          default(FALSE)
#  petition_type_id                 :integer
#  display_person_born_at           :boolean
#  display_person_birth_city        :boolean
#  active_rate_value                :float(24)        default(0.0)
#  owner_id                         :integer
#  owner_type                       :string(255)
#  slug                             :string(255)
#  reference_field                  :string(255)
#  answer_due_date                  :date
#

Globalize.fallbacks = { en: [:en, :nl], nl: [:nl, :en] }

class Petition < ActiveRecord::Base
  translates :name, :description, :initiators,
             :statement, :request, :slug,
             fallbacks_for_empty_translations: true,
             versioning: :paper_trail
  has_paper_trail only: [:name, :description, :initiators, :statement, :request]

  extend FriendlyId # must come after translates

  resourcify
  has_many :users, through: :roles

  friendly_id :name, use: :globalize

  POSSIBLE_STATES = [
    'withdrawn', # user or admin closed the petition for further signing
    'concept', # user is writing the petition
    'staging', # admin is moderating the petition before opening it for signing
    'live', # admin moderated the petition and opened it for signing
    'sign_elsewhere', # admin moderated a mirror of a petition elsewhere which can not be signed here
    'rejected', # admin found criteria the petition does not meet and motivated a rejection
    'to_process', # user prepares petition for hand over and collects last signatures
    'in_process', # petition is handed over and awaits answer
    'not_processed', # is expired, user asked for hand over, awaiting hand over
    'orphaned', # is expired, closed, and user does not respond
    'completed' # petition is expired and answered
  ].freeze

  scope :not_concept_or_staging, -> { where.not(status: ['concept', 'staging']) }
  scope :staging,   -> { where(status: 'staging') }
  scope :live,      -> { where(status: 'live') }
  scope :big,       -> { order(signatures_count: :desc) }
  scope :active,    -> { order(active_rate_value: :desc) }
  scope :newest,    -> { order(created_at: :desc) }
  scope :answered,  -> {
    joins(:updates).where(newsitems: { show_on_petition: true })
                   .order('newsitems.created_at DESC')
  }
  scope :past_date_projected, -> {
    live.where('date_projected < ?', Date.today).order(date_projected: :desc).limit(20)
  }
  scope :searchable, -> { where(status: ['live', 'sign_elsewhere']) }

  belongs_to :owner, class_name: 'User'
  belongs_to :office
  belongs_to :petition_type
  belongs_to :organisation

  has_many :images, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images, allow_destroy: true

  before_destroy :restrict_destroy_with_signatures
  has_many :new_signatures, dependent: :destroy
  has_many :signatures, dependent: :destroy

  has_many :updates, dependent: :destroy
  has_many :newsletters, dependent: :destroy
  has_many :task_statuses, dependent: :destroy

  def get_count
    from_redis = RedisPetitionCounter.count(self)
    return from_redis unless from_redis.zero?
    signatures_count
  end

  include StripWhitespace
  strip_whitespace :name, :description, :initiators, :statement, :request

  include TruncateString
  truncate_string :link1_text, :link2_text, :link3_text

  validates :name, presence: true
  validates :description, presence: true
  validates :initiators, presence: true
  validates :statement, presence: true
  validates :request, presence: true
  validates :petitioner_email, format: { with: User.email_regexp }

  validates :subdomain, format: { with: /\A[A-Za-z0-9-]+\z/, allow_blank: true }
  validates :subdomain, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :subdomain, exclusion: { in: %w[www help api handboek petitie petities loket webmaster helpdesk info assets assets0 assets1 assets2] }

  before_save :ensure_office_is_filled
  after_update :send_status_mail

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def last_sig_update
    key = redis.get("p-last-#{id}")
    Time.zone.at(key.to_i) if key
  end

  def active_rate
    short = 1.0

    total = 100.0

    now = Time.now + 1.day

    15.times do
      key_d = "p-d-#{id}-#{now.year}-#{now.month}-#{now.day}"
      key_h = "p-h-#{id}-#{now.year}-#{now.month}-#{now.day}-#{now.hour}"
      vd = redis.get(key_d) || 0
      vd = vd.to_f
      vh = redis.get(key_h) || 0
      vh = vh.to_f
      short += vd
      short += vh
      now = now - 1.day
    end

    a_rate = short / total

    # remove old active rate
    redis.zrem('active_rate', id)
    # add new active rate
    redis.zadd('active_rate', a_rate, id)

    a_rate
  end

  def update_active_rate!
    active_rate
  end

  def is_hot?
    redis_active_rate > 0.4
  end

  def redis_active_rate
    redis.zscore('active_rate', id) || 0
  end

  ## petition status summary
  def state_summary
    return 'draft' if concept?
    return 'closed' if is_closed?
    return 'signable' if is_live?
    return 'in_treatment' if in_treatment?
    status if %w[completed sign_elsewhere staging withdrawn orphaned].include?(status)
  end

  # All users who signed this petition should get an
  # answer
  def email_answer(answer = nil)
    ## fixme
  end

  def concept?
    status == 'concept'
  end

  def is_staging?
    %w[concept staging].include?(status)
  end

  def is_live?
    status == 'live'
  end

  def is_closed?
    %w[rejected to_process not_processed].include?(status)
  end

  def in_treatment?
    %w[in_process to_process not_processed].include?(status)
  end

  def answer
    updates.find_by(show_on_petition: true)
  end

  def redis_history_chart_json(hist = 10)
    start = Time.now - hist.day

    if created_at and start < created_at
      start = created_at
    end

    day_counts = []
    labels = []

    d = start

    hist.times do
      key = "p-d-#{id}-#{d.year}-#{d.month}-#{d.day}"
      c = redis.get(key) || 0
      c = c.to_i
      day_counts.push(c)

      labels.push("#{d.year}-#{d.month}-#{d.day}")

      if d > Time.zone.now.beginning_of_day
        break
      end
      d = d + 1.day
    end

    if labels.size > 20
      factor = (labels.size / 20.0).ceil
      labels = labels.map.with_index { |l, i| i % factor == 0 ? l : '' }
    end

    [day_counts, labels]
  end

  def links
    {
      links: [
        { link: link1, text: link1_text },
        { link: link2, text: link2_text },
        { link: link3, text: link3_text }
      ].select { |link| link[:link].present? },
      site: { link: site1, text: site1_text }
    }
  end

  def delete_keys
    keys_d = redis.keys("p-d-#{id}-*")
    keys_h = redis.keys("p-h-#{id}-*")

    redis.del(*keys_d) if keys_d.size > 0
    redis.del(*keys_h) if keys_h.size > 0
  end

  def create_raw_sql_barchart_keys
     sql = "
     SELECT
     COUNT(id), petition_id,
     DATE_FORMAT(confirmed_at, '%Y/%m/%d') as theday
     FROM signatures
     WHERE petition_id=#{id}
     AND confirmed=true
     AND confirmed_at IS NOT NULL
     GROUP BY
     YEAR(confirmed_at), MONTH(confirmed_at), DAY(confirmed_at)
     ORDER BY theday;"

     day_counts_array = ActiveRecord::Base.connection.execute(sql)

     puts
     puts "ACTIVE DAYS: #{day_counts_array.count}"
     puts

     day_counts_array.each do |row|
      count = row[0]
      id = row[1]
      year, month, day = row[2].split('/')
      day_key = "p-d-#{id}-#{year}-#{month.to_i}-#{day.to_i}"
      redis.set(day_key, count)
     end

  end

  def create_hour_keys
    hour24ago = Time.zone.now.beginning_of_day - 1.day
    # create year/day/hour scores!
    recent_signatures = self.signatures
                            .confirmed
                            .order("confirmed_at DESC")
                            .where("confirmed_at >= ?", hour24ago)

    if recent_signatures.count == 0
      return
    end

    puts
    puts "SIGS TODAY: #{recent_signatures.count}"
    puts

    recent_signatures.each do |signature|
      signature.set_redis_keys(true)
    end
  end

  def image
    @image ||= images.last if images.any?
  end

  def active_petition_type
    petition_type || office&.petition_type
  end

  def self.active_from_redis
    from_redis('active_rate')
  end

  def self.biggest_from_redis
    from_redis('petition_size')
  end

  def self.from_redis(key)
    petition_ids = Redis.current.zrevrange(key, 0, 160)
    Kaminari.paginate_array(live.where(id: petition_ids).sort_by { |f| petition_ids.index(f.id.to_s) })
  end

  private

  def ensure_office_is_filled
    self.office = Office.default_office if office.blank?
  end

  def restrict_destroy_with_signatures
    return if signatures.count < 100 && new_signatures.count < 100
    errors.add(:base, :will_not_destroy_that_much_signatures)
    false # or throw(:abort) in Rails 5.
  end

  def send_status_mail
    return unless status_changed? && persisted?
    PetitionStatusMail.new(self).call
  end

  def redis
    Redis.current
  end
end
