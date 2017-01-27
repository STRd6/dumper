class Tag < ApplicationRecord
  belongs_to :account
  belongs_to :content
end
