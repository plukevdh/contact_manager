class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :sex
      t.integer :age
      t.date :birthday

      t.string :email
      t.string :phone

      t.string :street
      t.string :city
      t.string :state
      t.integer :postcode

      t.timestamps
    end
  end
end
