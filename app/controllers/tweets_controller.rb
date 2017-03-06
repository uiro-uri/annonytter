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
    @tweets = Tweet.where({review_status: :draft})
    @tweet = Tweet.new
    session[:post_remains] ||= 0
  end

  def create
    if session[:post_remains] < 1
      redirect_to :root, flash: {error: "残り投稿回数がありません"}
    else
      Tweet.create(create_params)
      session[:post_remains] += -1
      redirect_to :root
    end
  end
  
  def vote
    votes=params[:vote]||{}
    votes.each do |id,v|
      tweet=Tweet.find(id)
      case v
      when "accept"
        tweet.accept_value+=1
        tweet.save
        if tweet.accept_value >= Settings[:accept_threshold]
          post tweet
        end
      when "reject"
        tweet.reject_value+=1
        tweet.review_status=:rejected if tweet.reject_value >= Settings[:reject_threshold]
        tweet.save
      end
    end
    session[:post_remains] += params[:vote].length/4
    redirect_to :root, flash: {success: "レビュー完了"}
  end

  def post tweet
    status = tweet.text
    option = {}
    media = valid_url?(tweet.image)
    option.update({media_ids: @client.upload(media)}) if media
    @client.update(status, option)
    tweet.destroy
  rescue
    redirect_to :root, flash: {error: 'ERROR!!'}
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