class AddStructuredPostalAddressToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :structured_postal_address, :string, default: ""
  end
end
