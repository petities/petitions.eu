class Petition < ActiveRecord::Base

  scope :live,      -> {where(status: 'live')}

  scope :big,       -> {order(signatures_count: :desc) }

  belongs_to :petition_type
  belongs_to :organisation

  def self.show_on_home
    Petition.order(last_confirmed_at: :desc).limit(25)
  end

  #default_scope :order => 'petitions.name ASC'

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

end


