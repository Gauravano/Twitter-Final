class CreateFollowMappings < ActiveRecord::Migration
  def change
    create_table :follow_mappings do |t|
      t.integer :followee_id
      t.integer :follower_id

      t.timestamps null: false
    end
  end
end
