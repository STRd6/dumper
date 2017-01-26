class Account < ApplicationRecord
  has_many :tokens

  before_save :refresh_perishable_token

  def refresh_perishable_token
    self.perishable_token = SecureRandom.uuid
  end
end
