class Coupon < ActiveRecord::Base
  belongs_to :user, optional: true
end

# == Schema Information
#
# Table name: coupons
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  state      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_coupons_on_user_id  (user_id)
#
