class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name, default: ""
      t.string :email, default: ""
      t.string :phone, default: ""
      t.string :street, default: ""
      t.string :city, default: ""
      t.string :state, default: ""
      t.string :zip, default: ""
      t.string :country, default: ""

      t.timestamps
    end
  end
end
