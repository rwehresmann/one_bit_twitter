require 'rails_helper'

RSpec.describe "Api::V1::Follows", type: :request do
  describe 'GET /api/v1/users/:id/following?page=:page' do
    context 'User exists' do
      let(:user) { create(:user) }
      let(:following_number) { Random.rand(15..25) }

      before { following_number.times { user.follow(create(:user)) } }

      it do
        get "/api/v1/users/#{user.id}/following?page=1"
        expect(response).to have_http_status(:success)
      end

      it 'returns right following' do
        get "/api/v1/users/#{user.id}/following?page=1"

        expect(json).to eql(each_serialized(Api::V1::UserSerializer, user.following_users[0..14]))
      end

      it 'returns 15 elemments on first page' do
        get "/api/v1/users/#{user.id}/following?page=1"
        expect(json.count).to eql(15)
      end

      it 'returns remaining elemments on second page' do
        get "/api/v1/users/#{user.id}/following?page=2"
        remaining = user.following_users.count - 15
        expect(json.count).to eql(remaining)
      end
    end

    context 'User dont exist' do
      let(:user_id) { -1 }

      before { get "/api/v1/users/#{user_id}/following" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end

  describe 'GET /api/v1/users/:id/followers?page=:page' do
    context 'User exists' do
      let(:user) { create(:user) }
      let(:followers_number) { Random.rand(15..25) }

      before { followers_number.times { create(:user).follow(user) } }

      it do
        get "/api/v1/users/#{user.id}/followers?page=1"
        expect(response).to have_http_status(:success)
      end

      it 'returns right followers' do
        get "/api/v1/users/#{user.id}/followers?page=1"
        expect(json).to eql(each_serialized(Api::V1::UserSerializer, user.followers[0..14]))
      end

      it 'returns 15 elemments on first page' do
        get "/api/v1/users/#{user.id}/followers?page=1"
        expect(json.count).to eql(15)
      end

      it 'returns remaining elemments on second page' do
        get "/api/v1/users/#{user.id}/followers?page=2"
        remaining = user.followers.count - 15
        expect(json.count).to eql(remaining)
      end
    end

    context 'User dont exist' do
      let(:user_id) { -1 }

      before { get "/api/v1/users/#{user_id}/followers" }

      it { expect(response).to have_http_status(:not_found) }
    end
  end
end
