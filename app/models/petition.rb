class Petition < ActiveRecord::Base

  #scope :visible, where("status = actief", true)
  def email2=(val)
    @email_valid = val  
  end

end


class Signature < ActiveRecord::Base

end

