class CreateStandups < ActiveRecord::Migration[7.1]
  def change
    create_table :standups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.date :date
      t.text :yesterday
      t.text :today
      t.text :blockers
      t.integer :commits_count
      t.integer :support_tickets_resolved
      t.text :extra_notes
      t.json :raw_integrations_data

      t.timestamps
    end
  end
end
