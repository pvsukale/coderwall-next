class Stream < Article
  # include ActiveModel::Model
  # attr_accessor :user, :sources

  # html_schema_type :BroadcastEvent
  attr_accessor :live

  def self.next_weekly_lunch_and_learn
    friday = (Time.now.beginning_of_week + 4.days)
  end

  def self.any_live?
    false
  end

  def self.live
    # return User.limit(rand(9)).order('RANDOM()').map do |u|
    #   Stream.new(
    #     user: u,
    #     sources: {'rmtp' => "rtmp://live.coderwall.com/coderwall/whatupdave"}
    #   )
    # end

    resp = Excon.get("#{ENV['QUICKSTREAM_URL']}/streams",
      headers: {
        "Content-Type" => "application/json" },
      idempotent: true,
      tcp_nodelay: true,
    )

    streamers = JSON.parse(resp.body).each_with_object({}) do |s, memo|
      memo[s['streamer']] = s
    end

    Stream.where(user: User.where(username: streamers.keys)).each do |s|
      s.live = true
    end
  end

  def preview_image_url
    "https://api.quickstream.io/coderwall/streams/#{user.username}.png?size=400x"
  end

  def rtmp
    "http://quickstream.io:1935/coderwall/ngrp:#{user.username}_all/jwplayer.smil"
  end
end
