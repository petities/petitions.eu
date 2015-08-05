class AddGroupToFaqs < ActiveRecord::Migration
  def change
    add_column :faqs, :group, :string
  end
end
