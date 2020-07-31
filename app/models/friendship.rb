class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friendship_id'

  def confirm_friendship(user)
    friendship = friends_user.find { |friend| friend.user_id = user }
    friendship.status = 'Confirmed'
    friendship.save
  end

  def approve_request
    @friendship.first.status = 'Confirmed'
    if @friendship.first.save
      @friendship = Friendship.create!(user_id: current_user.id, friendship_id: params[:id], status: 'Confirmed')
    end
    flash[:notice] = 'Friend Request Approved'
    redirect_to users_path
  end
end
