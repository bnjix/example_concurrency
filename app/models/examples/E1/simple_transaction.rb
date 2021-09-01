module Examples
  module E1
    class SimpleTransaction
      def self.demo
        new.demo
      end

      def demo
        visible_puts("In this example, we implement the code necessary for the user to pay for its current cart. Starting cart state: :unpaid, user balance: 10000\n\
          Transactions are useful to guarantee that every operation either succeeds completely, or fails completely. \n\
          https://en.wikipedia.org/wiki/ACID; https://www.postgresqltutorial.com/postgresql-transaction/; https://www.postgresql.org/docs/8.3/tutorial-transactions.html")
        example_without_transaction
        example_with_transaction
      end

      def example_without_transaction
        user = new_user
        cart = new_cart(user: user)
        make_update_ruby_survives(user: user, cart: cart)
        results("No transaction ruby lives", user: user, cart: cart)

        user2 = new_user
        cart2 = new_cart(user: user2)
        make_update_ruby_dies(user: user2, cart: cart2)
        rescue
        results("No transaction ruby dies", user: user2, cart: cart2)
      end

      def example_with_transaction
        user = new_user
        cart = new_cart(user: user)

        user.transaction do
          make_update_ruby_survives(user: user, cart: cart)
        end
        results("WITH transaction ruby lives", user: user, cart: cart)

        user2 = new_user
        cart2 = new_cart(user: user2)

        user2.transaction do
          make_update_ruby_dies(user: user2, cart: cart2)
        end
        rescue
        results("WITH transaction ruby dies", user: user2, cart: cart2)
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

      def results(message, user:, cart:)
        balance_cents = user.reload.balance_cents
        cart_state = cart.reload.payment_state
        success_str = (balance_cents == 50_00 && cart_state.to_sym == :paid) || (balance_cents == 100_00 && cart_state.to_sym == :unpaid)
        visible_puts("#{ message }, user balance #{ balance_cents }, cart state: #{ cart_state }, success: #{ success_str }")
      end

      def visible_puts(msg)
        puts "*"*100
        puts msg
        puts "*"*100
      end
    end
  end
end
