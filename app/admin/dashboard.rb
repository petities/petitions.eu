ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel t('desk.petition.allow_through') do
          table_for Petition.staging do
            column :name do |petition|
              link_to(petition.name, admin_petition_path(petition))
            end
            column :petitioner_name
            column :updated_at
          end
        end
      end

      column do
        panel t('active_admin.new_petitions') do
          table_for Petition.order(created_at: :desc).limit(20) do
            column :name do |petition|
              link_to(petition.name, admin_petition_path(petition))
            end
            column :status do |petition|
              t("petition.states.#{petition.status}")
            end
          end
        end
      end
    end
    columns do
      column do
        panel t('active_admin.past_date_projected') do
          table_for Petition.past_date_projected do
            column :date_projected
            column :name do |petition|
              link_to(petition.name, admin_petition_path(petition))
            end
            column :signatures_count, :get_count
            column :last_confirmed_at, :last_sig_update
          end
        end
      end
    end
  end
end
