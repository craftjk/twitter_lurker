class Status < ActiveRecord::Base
  attr_accessible :twitter_status_id, :body, :twitter_user_id

  validate :twitter_status_id, :uniqueness => true, :presence => true
  validate :twitter_user_id, :presence => true
  validate :body, :presence => true

  belongs_to :user,
              :primary_key => :twitter_user_id,
              :class_name => "User",
              :foreign_key => :twitter_user_id

  def self.fetch_statuses_for_user(user)
    status_query = Addressable::URI.new(
      :scheme => "https",
      :host => "api.twitter.com",
      :path => "1.1/statuses/user_timeline.json",
      :query_values => {:user_id => user.twitter_user_id}
    ).to_s

    statuses = parse_twitter_params(TwitterSession.get(status_query))
    user.sync_statuses(statuses)
  end

  def self.parse_twitter_params(params) #currently only does the first user if more than one are passed
    parsed_params = JSON.parse(params)
    parsed_params.map do |json_hash|
      Status.new(:twitter_status_id => json_hash["id_str"],
                  :body => json_hash["text"],
                  :twitter_user_id => json_hash["user"]["id_str"])
    end
  end
end