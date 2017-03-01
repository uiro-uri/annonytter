class AddReviewStatus < ActiveRecord::Migration[5.0]
  def change
    change_table :tweets do |t|
      t.integer :accept_value, default: 0
      t.integer :reject_value, default: 0
      t.integer :review_status, default: 0, null: false, limit: 2
    end
  end
end
