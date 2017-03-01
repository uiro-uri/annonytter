class Tweet < ApplicationRecord
    enum review_status: [:draft, :accept, :reject]
end
