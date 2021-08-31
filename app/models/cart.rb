class Cart < ActiveRecord::Base
  belongs_to :user, optional: true
end

# == Schema Information
#
# Table name: carts
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
#  index_carts_on_user_id  (user_id)
#
