class CreateCartsWithUniquenessConstraint < ActiveRecord::Migration[6.0]
  def change
    create_table :unique_carts do |t|
      t.belongs_to :user, index: { unique: true }
      t.integer :price_cents
      t.string :payment_state

      t.timestamps
    end
  end
end
