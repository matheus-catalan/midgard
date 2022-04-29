class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def make_uid
    loop do
      token = SecureRandom.hex(16).to_i(16).to_s(36)
      current_class = self.class
      unless current_class.where(uid: token).present?
        self.uid = token
        return
      end
    end
  end
end
