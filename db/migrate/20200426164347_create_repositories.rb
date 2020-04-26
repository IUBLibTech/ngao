class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :repository_id
      t.string :name
      t.datetime :last_updated_at
      t.integer :user_id
      t.timestamps
    end
  end
end