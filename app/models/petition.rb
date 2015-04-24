class Petition < ActiveRecord::Base

  scope :live,      -> {where(status: 'live')}

  scope :big,       -> {order(signatures_count: :desc) }

  belongs_to :petition_type
  belongs_to :organisation

  has_many :images, :as => :imageable, :dependent => :destroy

  def self.show_on_home
    Petition.order(last_confirmed_at: :desc).limit(25)
  end

  #default_scope :order => 'petitions.name ASC'
  has_many :new_signatures

  has_many :signatures do
    def confirmed
      find :all, :conditions => {:confirmed => true}
    end

    def special
      find :all, :conditions => {:confirmed => true, :special => true}, :order => 'sort_order asc, signed_at asc'
    end

    def recent
      find :all, :conditions => {:confirmed => true}, :order => 'signed_at desc'
    end

    def last_signed
      find( :all, :conditions => {:confirmed => true}, :order => 'signed_at DESC', :limit => 1).first
    end
  end

  def elapsed_time
      Time.now - (self.last_confirmed_at || Time.now)
  end

  def self.findbyname(query)
    where("name like ?", "%#{query}%")
  end


  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :initiators
  validates_presence_of :statement
  validates_presence_of :request
 
  validates_format_of :subdomain, :with => /\A[A-Za-z0-9-]+\z/, :allow_blank => true
  validates_uniqueness_of :subdomain, :case_sensitive => false, :allow_blank => true
  validates_exclusion_of :subdomain, :in => %w( www help api handboek petitie petities loket webmaster helpdesk info assets assets0 assets1 assets2 )
 
end


