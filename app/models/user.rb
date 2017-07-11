class User < ActiveRecord::Base
	
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable
end

class UserRelations
	SELF_FOLLOWED = 0
	FOLLOWED = 1
	NOT_FOLLOWED = 2
end

def follow_relation user_id
	return UserRelations::SELF_FOLLOWED if user_id == id

	if FollowMapping.where(:followee_id => user_id,:follower_id => id).length > 0
		return UserRelations::FOLLOWED
	else
		return UserRelations::NOT_FOLLOWED
	end
end

def can_follow user_id
	return follow_relation(user_id) == UserRelations::NOT_FOLLOWED
end

def can_un_follow user_id
	return follow_relation(user_id) == UserRelations::FOLLOWED
end

def followee_ids
	FollowMapping.where(follower_id: id).pluck(:followee_id)
end

def feed
	users = followee_ids
	users << id
	Tweet.where(user_id: users).order(created_at: :desc)
end

end