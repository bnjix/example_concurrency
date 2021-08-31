module Examples
  class UniquenessConstraint
    def self.demo
      new.demo
    end

    def demo
      puts "In this example, we create a new cart for an user"
      example_without_uniqueness_constraint
      example_with_uniqueness_constraint
    end

    def example_without_transaction
      puts "Here is what happens if our ruby code dies in the middle of the payment without transactiona"
      user = User.create!(balance_cents: 100_00)
      user = Cart.create!(user: user)
    end

    def example_with_transaction
    end
  end
end
