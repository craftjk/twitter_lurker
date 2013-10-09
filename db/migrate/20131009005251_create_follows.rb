class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.string :twitter_follower_id, :not_null => true
      t.string :twitter_followee_id, :not_null => true

      t.timestamps
    end

    add_index :follows, [:twitter_follower_id, :twitter_followee_id], { :unique => true }
  end
end
