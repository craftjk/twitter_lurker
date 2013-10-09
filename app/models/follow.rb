class Follow < ActiveRecord::Base
  attr_accessible :twitter_follower_id, :twitter_followee_id

  validates :twitter_follower_id, :presence => true
  validates :twitter_followee_id, :presence => true


end
