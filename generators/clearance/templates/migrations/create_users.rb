class ClearanceCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|
      t.string   :email
      t.string   :encrypted_password, :limit => 128
      t.string   :salt,               :limit => 128
      t.string   :perishable_token
      t.string   :persistence_token
      t.boolean  :email_confirmed, :default => false, :null => false
      t.timestamps
    end

    add_index :users, [:id, :perishable_token]
    add_index :users, :email
  end

  def self.down
    drop_table :users
  end
end
