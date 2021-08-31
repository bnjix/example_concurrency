class User < ActiveRecord::Base
end

# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  name          :string
#  balance_cents :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
