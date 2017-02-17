class TweetsController < ApplicationController
  before_action :twitter_client, except: :new

  def twitter_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = Settings[:twitter_key]
      config.consumer_secret = Settings[:twitter_secret]
      config.access_token = Settings[:twitter_token]
      config.access_token_secret = Settings[:twitter_token_secret]
    end
  end
  
  def new
    @tweet = Tweet.new
  end

  def create
    Tweet.create(create_params)
    redirect_to :root
  end
  
  def post
    tweet = Tweet.last
    status = tweet.text
    media = open(tweet.image)
    media.rewind
    @client.update_with_media(status, media)
    redirect_to :root
  end

  private
  def create_params
    params.require(:tweet).permit(:text, :image)
  end
end