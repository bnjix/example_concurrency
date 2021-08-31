class CreateBaseTables < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :balance_cents

      t.timestamps
    end

    create_table :carts do |t|
      t.belongs_to :user
      t.integer :price_cents
      t.string :payment_state

      t.timestamps
    end
  end
end
