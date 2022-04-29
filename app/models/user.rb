class User < ApplicationRecord
  has_secure_password
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  before_create :make_uid
  has_many :devices, dependent: :destroy
  has_many :sessions, dependent: :destroy
end
