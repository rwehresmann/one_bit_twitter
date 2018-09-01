require 'rails_helper'

RSpec.describe User do
  describe "#timeline" do
    it "returns the user tweets and from how he's following ordered by creation date" do
      user_1 = create(:user)
      user_2 = create(:user)

      user_1.follow(user_2)

      build_tweets_outside_timeline
      tweets_from_timeline = build_tweets_from_timeline(user_1, user_2)

      expect(user_1.timeline).to eq(tweets_from_timeline)      
    end
  end

  def build_tweets_from_timeline(user_1, user_2)
    second_tweet_to_return = create(:tweet, user: user_1)
    second_tweet_to_return.update(created_at: Time.now + 1.day)

    first_tweet_to_return = create(:tweet, user: user_2)
    first_tweet_to_return.update(created_at: Time.now + 2.days)
    
    third_tweet_to_return = create(:tweet, user: user_2)

    [ first_tweet_to_return, second_tweet_to_return, third_tweet_to_return ]
  end

  def build_tweets_outside_timeline
    create_pair(:tweet)
  end
end