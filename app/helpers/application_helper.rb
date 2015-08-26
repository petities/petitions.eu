module ApplicationHelper
  def is_homepage?
    controller_name == 'petitions' && action_name == 'index'
  end
end
