class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.references :organization, null: false, foreign_key: true
      t.string :role
      t.string :github_username
      t.string :support_tool_username

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
