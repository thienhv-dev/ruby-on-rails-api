class Post < ApplicationRecord
  validates :title, presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 5000 }

  belongs_to :user

  def self.ransackable_attributes(auth_object = nil)
    %w[title content created_at updated_at user_id email]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
