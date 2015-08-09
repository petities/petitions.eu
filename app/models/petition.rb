class Petition < ActiveRecord::Base
  resourcify
  translates :name, :description, :initiators, :statement, :request, :versioning => :paper_trail
  has_paper_trail :only => [:name, :description, :initiators, :statement, :request]

  serialize :locale_list, Array

  STATUS_LIST = [
    'published',
    'live',
    'withdrawn',
    'draft',
    'concept',
    'staging',
    'not_signable_here',
    'to_process',
    'ghost',
    'in_process',
    'not_processed',
    'rejected',
    'completed'
  ]
    
  scope :live,      -> {where(status: 'live')}
  scope :big,       -> {order(signatures_count: :desc)}
  scope :active,     -> {order(active_rate_value: :desc)}
  scope :newest,     -> {order(created_at: :desc)}

  belongs_to :petition_type
  # belongs_to :organisation

  has_many :images, :as => :imageable, :dependent => :destroy

  #default_scope :order => 'petitions.name ASC'
  
  has_many :new_signatures
  has_many :signatures do
    def confirmed
      where(confirmed: true)
    end

    def special
      where(confirmed: true, special: true).order('sort_order ASC, signed_at ASC')
    end

    def recent
      where(confirmed: true).order('signed_at DESC')
    end

    def last_signed
      where(confirmed: true).order('signed_at DESC').limit(1).first
    end
  end

  def elapsed_time
    Time.now - (self.last_confirmed_at || Time.now)
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

<<<<<<< Updated upstream
  after_update :send_status_mail

  def send_status_mail
    PetitionMailer.status_change_mail(self).deliver if self.status_changed?
  end

  def active_rate
    if self.signatures_count > 0
      self.signatures.confirmed.where('confirmed_at >= ?', 1.day.ago).size.to_f / self.signatures_count.to_f
    else
      0
    end
=======
  def active_rate
    self.signatures.confirmed.where('confirmed_at >= ?', 1.day.ago).size
>>>>>>> Stashed changes
  end

  def update_active_rate!
    self.active_rate_value = self.active_rate
    save
  end

  def is_hot?
<<<<<<< Updated upstream
    self.active_rate_value > 0.05
=======
    self.active_rate_value > 1
>>>>>>> Stashed changes
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
 
end


