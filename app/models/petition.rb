class Petition < ActiveRecord::Base
  extend ActionView::Helpers::TranslationHelper
  extend FriendlyId

  resourcify
  translates :name, :description, :initiators, :statement, :request, :slug, :versioning  => :paper_trail
  has_paper_trail :only => [:name, :description, :initiators, :statement, :request]

  serialize :locale_list, Array

  # add slug_column?
  # write migration?
  friendly_id :name, use: :globalize

  STATUS_LIST = [
    # we can view it but not sign?
    [ t('petition.published'),         'published'],
    # we take the petition offline.
    [ t('petition.withdrawn'),         'withdrawn'],
    # no confirmed author
    [ t('petition.draft'),             'draft'],
    # still building author is confirmed
    [ t('petition.concept'),           'concept'],
    # admin has to review the petition
    [ t('petition.staging'),           'staging'],
    # admin reviewed the state
    [ t('petition.live'),              'live'],
    # petitions we do not sign here
    [ t('petition.not_signable_here'), 'not_signable_here'],
    # admin does not like this petition
    [ t('petition.rejected'),          'rejected'],
    # petition should go to goverment
    [ t('petition.to_process'),        'to_process'],
    # no owner?
    [ t('petition.ghost'),             'ghost'],
    # petition is at goverment
    [ t('petition.in_process'),        'in_process'],
    # petition is not at goverment
    [ t('petition.not_processed'),     'not_processed'],
    # there is a goverment response
    # we are done!
    [ t('petition.completed'),         'completed'],
  ]

  # loketten
  LOKET_ADMIN = [
    [ t('petition.withdrawn'),         'withdrawn'],
    [ t('petition.to_process'),        'to_process'],
  ]

  # petitionaris
  PETITIONARIS = [
    [t('petition.stageing'), 'stageing'],   # offer for review
  ]

  scope :live,      -> {where(status: 'live')}
  scope :big,       -> {order(signatures_count: :desc)}
  scope :active,     -> {order(active_rate_value: :desc)}
  scope :newest,     -> {order(created_at: :desc)}

  belongs_to :owner, class_name: 'User'

  belongs_to :petition_type
  # belongs_to :organisation

  has_many :images, :as => :imageable,  :dependent => :destroy
  accepts_nested_attributes_for :images

  #default_scope :order => 'petitions.name ASC'

  has_many :new_signatures

  has_many :signatures do
    def confirmed
      where(confirmed: true)
    end

    def special
      # where(confirmed: true, special: true).order('sort_order ASC, signed_at ASC')
      where(confirmed: true).order('sort_order DESC, signed_at ASC')
    end

    def recent
      where(confirmed: true).order('signed_at DESC')
    end

    def last_signed
      where(confirmed: true).order('signed_at DESC').limit(1).first
    end
  end

  has_many :updates

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :initiators
  validates_presence_of :statement
  validates_presence_of :request

  validates_format_of :subdomain, :with => /\A[A-Za-z0-9-]+\z/, :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false, :allow_blank => true
  validates_exclusion_of :subdomain, :in => %w( www help api handboek petitie petities loket webmaster helpdesk info assets assets0 assets1 assets2 )

  after_update :send_status_mail

  def should_generate_new_friendly_id?
      return true
      name_changed?
  end

  def send_status_mail
    PetitionMailer.status_change_mail(self).deliver if self.status_changed?
  end

  def elapsed_time
    Time.now - (self.last_confirmed_at || Time.now)
  end

  def active_rate
    if self.signatures_count > 0
      self.signatures.confirmed.where('confirmed_at >= ?', 1.day.ago).size.to_f / self.signatures_count.to_f
    else
      0
    end
  end

  def update_active_rate!
    self.active_rate_value = self.active_rate
    save
  end

  def is_hot?
    self.active_rate_value > 0.05
  end

  ## petition status summary
  def state_summary
    return 'draft' if self.is_draft?
    return 'closed' if self.is_closed?
    return 'signable' if self.is_live?
    return 'in_treatment' if self.in_treatment?
    return 'is_answered' if self.is_answered?
  end

  ## edit a given petition
  def can_edit_petition? user
    if user.has_role? :admin
      return true
    end

    office = Office.find(self.office_id)

    if office
      if user.has_role? office, :admin
        return true
      end
    end

    return False
  end

  def is_draft?
    ['concept',
     'draft',
     'staging',
    ].include? self.status
  end

  def is_live?
    ['live',
     'not_signable_here'].include? self.status
  end

  def is_closed?
    ['withdrawn',
     'rejected',
     'to_process',
     'not_processed'].include? self.status
  end

  def in_treatment?
    ['in_process',
     'to_process',
     'not_processed'].include? self.status
  end

  def is_answered?
    ['completed'].include? self.status
  end

  def history_chart_json
    self.signatures.confirmed.map{|signature| signature.confirmed_at }
        .compact
        .group_by{|signature| signature.strftime("%Y-%m-%d")}
        .map{|group| group[1].size}#.to_json.html_safe
  end

  def inc_signatures_count!
    self.signatures_count += 1
    save
  end

  def links
    {
      links: [
        { link: link1, text: link1_text },
        { link: link2, text: link2_text },
        { link: link3, text: link3_text },
      ].select{|link| link[:link].present?},
      site: { link: site1, text: site1_text }
    }
  end

end


