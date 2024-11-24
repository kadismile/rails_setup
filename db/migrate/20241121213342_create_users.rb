class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :password_digest
      t.string :gender
      t.boolean :is_active

      t.timestamps
    end
  end
end
