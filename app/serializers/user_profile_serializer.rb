class UserProfileSerializer < ActiveModel::Serializer
  attributes :id, :email, :name

  has_many :posts, serializer: PostSerializer
  has_many :followers, serializer: UserSerializer
  has_many :following, serializer: UserSerializer
end
