module ApplicationHelper
  def is_homepage?
    controller_name == 'petitions' && action_name == 'index'
  end

  def title(value)
    content_for(:title) { value + ' - ' }
  end
end
