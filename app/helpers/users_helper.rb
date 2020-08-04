module UsersHelper
  def friendship_status_check(user_id)
    friendship_status(user_id) if current_user != user_id
  end

  def friendship_status(user_id)
    if current_user.friend?(user_id)
      link_to 'Unfriend', friendship_path(user_id, method_name: 'Delete'), method: :delete, class: 'friend_button'
    elsif current_user.pending_friends.include?(user_id)
      link_to 'Cancel', friendship_path(user_id, method_name: 'Cancel'), method: :delete, class: 'friend_button'
    elsif current_user.pending_received_requests.include?(user_id)
      render 'links', user_id: user_id
    else
      link_to 'Send Request', friendships_path(friendship_id: user_id), method: :post, class: 'friend_button'
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
