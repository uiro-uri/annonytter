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
    @tweets = Tweet.all
    @tweet = Tweet.new
  end

  def create
    Tweet.create(create_params)
    redirect_to :root
  end
  
  def post
    if (id = params[:tweet][:id]).empty?
      tweet = Tweet.last
    else
      tweet = Tweet.find(id)
    end
    
    status = tweet.text
    option = {}
    media = valid_url?(tweet.image)
    option.update({media_ids: @client.upload(media)}) if media
    @client.update(status, option)
    redirect_to :root, flash: {success: "success to post #{tweet.attributes}"}
  rescue
    redirect_to :root, flash: {error: 'ERROR!!'}
  end
  
  def vote
    votes=params[:vote]
    votes.each do |id,value|
      tweet=Tweet.find(id)
      case value
      when "accept"
        tweet.accept_value+=1
      when "reject"
        tweet.reject_value+=1
      end
      tweet.save
    end
    redirect_to :root, flash: {success: "Thank you for revewing!"}
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