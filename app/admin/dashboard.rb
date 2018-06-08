ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel t('desk.petition.allow_through') do
          ul do
            Petition.where(status: 'staging').map do |petition|
              li link_to(petition.name, admin_petition_path(petition))
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
