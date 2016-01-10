module UpdateHelper
  def can_edit_update?

    return false unless user_signed_in?

    return true if current_user.has_role?(:admin)

    return true if @petition && current_user.has_role?(:admin, @petition)

    return true if @office && current_user.has_role?(:admin, @office)

  end
end
