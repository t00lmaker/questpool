class Alternative < ApplicationRecord
  belongs_to :question, inverse_of: :alternatives
end
