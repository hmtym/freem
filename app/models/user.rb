class User < ApplicationRecord
    before_save :convert_password
    has_many :products
    has_many :userlikes
    
    def convert_password
        self.password = User.generate_password(self.password)
    end
    def self.generate_password(password)
        salt = "h!hgamcRAdh38bajhvgai17ysvb"
        Digest::MD5.hexdigest(salt + password)
    end
    
    # バリデーション
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :name, presence: true
    validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}
    validates :password, presence: true, length:{minimum: 8}, confirmation: true
end
