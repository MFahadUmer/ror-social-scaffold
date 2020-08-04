class FriendshipsController < ApplicationController
  def create
    @friendship = current_user.friendships.build(friendship_params)
    @friendship.status = 'Pending'
    return unless @friendship.save

    flash[:notice] = 'Friend Request Sent'
    redirect_to users_path
  end

  def update
    @friendship = Friendship.where("friendship_id = #{current_user.id}"). where("user_id = #{params[:id]}")
    @friendship.first.status = 'Confirmed'
    return unless @friendship.first.save

    @friendship = Friendship.create!(user_id: current_user.id, friendship_id: params[:id], status: 'Confirmed')
    flash[:notice] = 'Friend Request Approved'
    redirect_to users_path
  end

  def destroy
    @user = Friendship.all
    if params[:method_name] == 'Delete'
      flash[:notice] = 'Friend Unfriended' if @user.delete_friendship(current_user.id, params[:id])
    elsif params[:method_name] == 'Cancel' || params[:method_name] == 'Reject'
      if @user.cancel_friendship(params[:method_name], current_user.id, params[:id])
        flash[:notice] = "Friend Request #{params[:method_name]}ed "
      end
    end
    redirect_to users_path
  end

  private

  def friendship_params
    params.permit(:friendship_id)
  end
end
