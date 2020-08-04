class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friendship_id'

  def self.delete_friendship(current_user, friendship_id)
    friendship = Friendship.where("friendship_id = #{current_user}"). where("user_id = #{friendship_id}")
    friendship.first.destroy
    reverse_friendship = Friendship.where("user_id = #{current_user}"). where("friendship_id = #{friendship_id}")
    reverse_friendship.first.destroy
  end

  def self.cancel_friendship(method_name, current_user, friendship_id)
    if method_name == 'Cancel'
      reverse_friendship = Friendship.where("user_id = #{current_user}"). where("friendship_id = #{friendship_id}")
      reverse_friendship.first.destroy
    elsif method_name == 'Reject'
      friendship = Friendship.where("friendship_id = #{current_user}"). where("user_id = #{friendship_id}")
      friendship.first.destroy
    end
  end
end
