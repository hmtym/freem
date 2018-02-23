class Product < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :userlikes
  
  def like_from?(user)
    self.userlikes.exists?(user_id: user.id)
  end
  
  # def initialize(params)
  #   @user_name = params[:name]
  #   @image1 = params[:image1]
  # end
end
