class CreateEads < ActiveRecord::Migration[5.2]
  def change
    create_table :eads do |t|
      t.string :filename
      t.datetime :last_updated_at
      t.datetime :last_indexed_at
      t.integer :repository_id
      t.timestamps
    end
  end
end
