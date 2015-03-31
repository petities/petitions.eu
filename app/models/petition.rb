class Petition < ActiveRecord::Base

  def email2=(val)
    @email_valid = val  
  end

end
