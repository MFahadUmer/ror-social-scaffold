module UsersHelper
  def friendship_status_check(user_id)
    friendship_status(user_id) if current_user != user_id
  end

  def friendship_status(user_id)
    if current_user.friend?(user_id)
      link_to 'Unfriend', friendship_path(user_id, method_name: 'delete'), method: :delete, class: 'friend_button'
    elsif current_user.pending_friends.include?(user_id)
      link_to 'Cancel', friendship_path(user_id, method_name: 'cancel'), method: :delete, class: 'friend_button'
    elsif current_user.pending_received_requests.include?(user_id)
      link_to 'Cancel', friendship_path(user_id, methodname: 'cancel'), method: :delete, class: 'friend_button'
      link_to 'Approve', friendship_path(user_id), method: :put, class: 'friend_button'
    else
      link_to 'Send Friend Request', friendships_path(user_id), method: :post, class: 'friend_button'
    end
  end

  def mutual_friends(mutual1, mutual2)
    mutual = []
    mutual1.each do |x|
      mutual << x if mutual2.include?(x)
    end
    mutual
  end

  def others_post(user)
    if current_user.friend?(user)
      render @posts
    else
      tag.h4 "You both must be friend to see other's posts"
    end
  end
end
