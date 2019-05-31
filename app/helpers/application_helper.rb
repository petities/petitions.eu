module ApplicationHelper
  def homepage?
    controller_name == 'petitions' && action_name == 'index'
  end

  def title(value)
    content_for(:title) { value.to_s + ' - ' }
  end

  def header_username(current_user)
    if current_user&.name.present?
      current_user.name
    elsif current_user
      current_user.email
    else
      t('my.petitioner')
    end
  end
end
