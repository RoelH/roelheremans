class PromptSubmission < ApplicationRecord
  validates :prompt_text, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "must be a valid email address" }, allow_blank: true
end
