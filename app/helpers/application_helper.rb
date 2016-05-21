module ApplicationHelper
  def homepage?
    controller_name == 'petitions' && action_name == 'index'
  end

  def title(value)
    content_for(:title) { value.to_s + ' - ' }
  end
end
