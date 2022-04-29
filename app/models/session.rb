class Session < ApplicationRecord
  belongs_to :user
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :should_expire, presence: true
  validates :user_id, presence: true, uniqueness: true
end
