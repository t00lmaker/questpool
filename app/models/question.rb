class Question < ApplicationRecord
  belongs_to :user
  has_many :alternatives
  has_many :hints
end
