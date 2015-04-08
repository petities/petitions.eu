class Petition < ActiveRecord::Base


  belongs_to :petition_type
  belongs_to :organisation

end


