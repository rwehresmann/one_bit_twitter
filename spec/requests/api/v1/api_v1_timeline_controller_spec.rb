require 'rails_helper'

RSpec.describe Api::V1::TimelineController, type: :request do
  describe "GET /api/v1/timeline" do
    context "when user is authenticated" do
      it "returns the timeline json" do
        user = create(:user)
        create_pair(:tweet, user: user)

        get api_v1_timeline_path, headers: header_with_authentication(user)
        
        expect(json).to eq(each_serialized(Api::V1::TweetSerializer, user.timeline))
      end
    end

    context "when user isn't authenticated" do
      it_behaves_like :deny_without_authorization, :get, '/api/v1/timeline'
    end
  end
end