class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :userlikes
  
  def like_from?(user)
    self.product_likes.exists?(user_id: user.id)
  end
end
