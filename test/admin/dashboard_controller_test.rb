require 'active_admin_helper'

module Admin
  # Make sure we can see the dashboard
  class DashboardControllerTest < ActionController::TestCase
    include ActiveAdminHelper

    test 'should get index' do
      get :index
      assert_response :success
      assert_select 'h3', I18n.t('desk.petition.allow_through')
      assert_select 'h3', I18n.t('active_admin.new_petitions')
      assert_select 'h3', I18n.t('active_admin.past_date_projected')
    end
  end
end
