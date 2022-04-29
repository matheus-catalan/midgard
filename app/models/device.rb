class Device < ApplicationRecord
  belongs_to :user
  validates :ip_address, presence: true, length: { maximum: 15 },
                         format: { with: /\A^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/i },
                         uniqueness: { case_sensitive: false }
  validates :user_agent, presence: true, length: { maximum: 255 }
  validates :platform, presence: true, length: { maximum: 50 }
end
