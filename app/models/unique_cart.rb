class UniqueCart < ActiveRecord::Base
  belongs_to :user, optional: true
end

# == Schema Information
#
# Table name: unique_carts
#
#  id            :bigint           not null, primary key
#  user_id       :bigint
#  price_cents   :integer
#  payment_state :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_unique_carts_on_user_id  (user_id) UNIQUE
#
