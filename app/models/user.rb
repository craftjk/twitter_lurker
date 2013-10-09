class User < ActiveRecord::Base
  attr_accessible :twitter_user_id, :screen_name

  validate :twitter_user_id, :uniqueness => true, :presence => true
  validate :screen_name, :uniqueness => true, :presence => true

  has_many :statuses,
            :primary_key => :twitter_user_id,
            :class_name => "Status",
            :foreign_key => :twitter_user_id

  def self.fetch_by_screen_name(screen_name)
    user_query = Addressable::URI.new(
      :scheme => "https",
      :host => "api.twitter.com",
      :path => "1.1/users/lookup.json",
      :query_values => {:screen_name => screen_name}
    ).to_s

    parse_twitter_params(TwitterSession.get(user_query))
  end

  def sync_statuses(new_statuses)
    status_ids = self.statuses.map { |el| el.twitter_status_id }

    new_statuses.each do |new_status|
      new_status.save unless status_ids.include?(new_status.twitter_status_id)
    end

  end

  def self.parse_twitter_params(params) #currently only does the first user if more than one are passed
    params_hash = JSON.parse(params).pop

    User.new(:twitter_user_id => params_hash["id_str"], :screen_name => params_hash["screen_name"])
  end
end
