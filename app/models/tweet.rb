class Tweet < ApplicationRecord
    validates :text, presence: true
    validates :text, length: {maximum: 140}
    enum review_status: [:draft, :accepted, :rejected]
end
