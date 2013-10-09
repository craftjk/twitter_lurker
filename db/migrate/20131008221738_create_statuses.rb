class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :twitter_status_id, :not_null => true
      t.string :body, :not_null => true
      t.string :twitter_user_id, :not_null => true

      t.timestamps
    end

    add_index :statuses, :twitter_status_id, { :unique => true }

  end
end
