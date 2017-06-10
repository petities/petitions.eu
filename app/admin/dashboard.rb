ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    div class: 'blank_slate_container', id: 'dashboard_default_message' do
      span class: 'blank_slate' do
        span I18n.t('active_admin.dashboard_welcome.welcome')
        small I18n.t('active_admin.dashboard_welcome.call_to_action')
      end
    end

    columns do
      column do
        panel 'Active Petitions' do
          ul do
            Petition.live.order(active_rate_value: :desc).limit(10).map do |petition|
              li link_to(petition.name, admin_petition_path(petition))
              # li petition.active_rate_value
            end
          end
        end
      end

      column do
        panel 'new petitions' do
          ul do
            Petition.order(created_at: :desc).limit(20).map do |petition|
              li link_to(petition.name, admin_petition_path(petition))
              # li petition.active_rate_value
            end
          end
        end
      end
    end
  end # content
end
