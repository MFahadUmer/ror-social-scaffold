require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { User.create!(name: 'Mohammad', email: 'jay@gmail.com', password: 'abc123456789') }
  let(:user2) { User.create!(name: 'James', email: 'fahad@gmail.com', password: 'abc123456789') }
  let(:friend1) { user1.friendships.create(friend_id: 2) }
end
