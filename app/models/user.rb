class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { minimum: 5, maximum: 20 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: VALID_EMAIL_REGEX, message: 'The email is not valid' }
  validates :password, presence: true, length: { minimum: 6, maximum: 32 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :friendships
  has_many :friends_user, class_name: 'Friendship', foreign_key: 'friendship_id'
  has_many :folks, through: :friends_user, source: :friend
  # Confirmed Friendship
  has_many :confirmed_friendships, -> { where status: 'Confirmed' }, class_name: 'Friendship'
  has_many :confirmed_friends, through: :confirmed_friendships, source: :friend
  # sending Friend Request
  has_many :pending_friendships, -> { where status: 'Pending' }, class_name: 'Friendship', foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend
  # Received Friend Request
  has_many :pending_friendship, -> { where status: 'Pending' }, class_name: 'Friendship', foreign_key: 'friendship_id'
  has_many :pending_received_requests, through: :pending_friendship, source: :user

  def friends_and_own_posts
    Post.where(user: confirmed_friends).or(Post.where(user: self)).ordered_by_most_recent
  end

  def mutual_friends
    friends_array = friendships.map { |friendship| friendship.friendship_id if friendship.status == 'Confirmed' }
    friends_array.compact
  end

  def friend?(user)
    confirmed_friends.include?(user)
  end
end
