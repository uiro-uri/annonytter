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
    if params[:id]
      tweet = Tweet.find(params[:id])
    else
      tweet = Tweet.last
    end
    
    status = tweet.text
    option = {}
    media = valid_url?(tweet.image)
    option.update({media_ids: @client.upload(media)}) if media
    @client.update(status, option)
    redirect_to :root
  end

  private
  def create_params
    params.require(:tweet).permit(:text, :image)
  end
  
  def valid_url?(url)
    open(url)
  rescue
    false
  end
end