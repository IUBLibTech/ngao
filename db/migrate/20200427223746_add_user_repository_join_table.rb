class AddUserRepositoryJoinTable < ActiveRecord::Migration[5.2]
  def change
    create_join_table :repositories, :users do |t|
      t.index :repository_id
      t.index :user_id
    end
  end
end
