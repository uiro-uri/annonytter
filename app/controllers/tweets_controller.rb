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
    if tweet.accepted?
      status = tweet.text
      option = {}
      media = valid_url?(tweet.image)
      option.update({media_ids: @client.upload(media)}) if media
      @client.update(status, option)
      tweet.destroy
      redirect_to :root, flash: {success: "success to post #{tweet.attributes}"}
    else
      redirect_to :root, flash: {error: 'error: This tweet has not accepted'}
    end
  rescue
    redirect_to :root, flash: {error: 'ERROR!!'}
  end
  
  def vote
    votes=params[:vote]||{}
    votes.each do |id,v|
      tweet=Tweet.find(id)
      case v
      when "accept"
        tweet.accept_value+=1
        tweet.review_status=:accepted if tweet.accept_value >= Settings[:accept_threshold]
      when "reject"
        tweet.reject_value+=1
        tweet.review_status=:rejected if tweet.reject_value >= Settings[:reject_threshold]
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