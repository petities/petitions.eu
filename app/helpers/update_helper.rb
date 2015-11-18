module UpdateHelper
  def can_edit_update? update
    
    if not user_signed_in? 
      return false
    end
      
    if current_user.has_role?(:admin) 
      return true
    end
      
    if @petition
      if current_user.has_role?(:admin, @petition)
         return true
      end
    end
    
    if @office
      if current_user.has_role?(:admin, @office) 
        return true
      end
    end
    
  end  
end