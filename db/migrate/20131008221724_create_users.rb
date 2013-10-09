class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :twitter_user_id, :not_null => true
      t.string :screen_name, :not_null => true

      t.timestamps
    end

    add_index :users, :twitter_user_id, { :unique => true }
  end
end
