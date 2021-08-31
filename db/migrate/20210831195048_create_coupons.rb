class CreateCoupons < ActiveRecord::Migration[6.0]
  def change
    create_table :coupons do |t|
      t.belongs_to :user
      t.string :state

      t.timestamps
    end
  end
end
