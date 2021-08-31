module Examples
  class SimpleTransaction
    def self.demo
      new.demo
    end

    def demo
      visible_puts("In this example, we implement the code necessary for the user to pay for its current cart. Starting cart state: :unpaid, user balance: 10000")
      example_without_transaction
      example_with_transaction
    end

    def example_without_transaction
      user = new_user
      cart = new_cart(user: user)
      make_update_ruby_survives(user: user, cart: cart)
      visible_puts("No transaction ruby lives; user balance #{ user.balance_cents }, cart state: #{ cart.payment_state }")

      user2 = new_user
      cart2 = new_cart(user: user2)
      make_update_ruby_dies(user: user2, cart: cart2)
      rescue
      visible_puts("No transaction ruby dies; user balance #{ user2.reload.balance_cents }, cart state: #{ cart2.payment_state }")
    end

    def example_with_transaction
      user = new_user
      cart = new_cart(user: user)

      user.transaction do
        make_update_ruby_survives(user: user, cart: cart)
      end
      visible_puts("WITH transaction ruby lives; user balance #{ user.balance_cents }, cart state: #{ cart.payment_state }")

      user2 = new_user
      cart2 = new_cart(user: user2)

      user2.transaction do
        make_update_ruby_dies(user: user2, cart: cart2)
      end
      rescue
      visible_puts("WITH transaction ruby dies; user balance #{ user2.reload.balance_cents }, cart state: #{ cart2.payment_state }")
    end

    def make_update_ruby_survives(user:, cart:)
      mark_cart_as_paid!(cart)
    end

    def make_update_ruby_dies(user:, cart:)
      mark_cart_as_paid!(cart) { raise "something unexpected happened" }
    end

    def mark_cart_as_paid!(cart)
      user = cart.user
      user.update!(balance_cents: user.balance_cents - cart.price_cents)
      yield if block_given?
      cart.update!(payment_state: :paid)
    end

    def new_user
      User.create!(balance_cents: 100_00)
    end

    def new_cart(user:)
      Cart.create!(user: user, price_cents: 50_00, payment_state: :unpaid)
    end

    def visible_puts(msg)
      puts "*"*100
      puts msg
      puts "*"*100
    end
  end
end
