module Examples
  module E2
    class UniquenessConstraint
      def self.demo
        new.demo
      end

      def demo
        visible_puts("In this example, we simulate what happens if the same user tries to create 2 carts in short succession.\
          This can happen if there's a client bug triggering 2 request to come very close together. Users can only have one cart.\
          The only way to guarantee this is to use a DB uniqueness constraint -- https://www.postgresqltutorial.com/postgresql-unique-constraint/")
        example_without_uniqueness_constraint
        example_with_uniqueness_constraint
      end

      def example_without_uniqueness_constraint
        trigger_race_condition(Cart)
      end

      def example_with_uniqueness_constraint
        trigger_race_condition(UniqueCart)
      end

      def trigger_race_condition(model)
        visible_puts("model: #{ model }")
        user = User.create!
        2.times.map do
          # Imagine these are 2 web requests hitting your server
          Thread.new { first_or_create(model, user) }
        end.each(&:join)
        cart_count = model.where(user: user).count
        visible_puts("Resulting cart count: #{ cart_count }, success: #{ cart_count == 1 }")
      end

      def first_or_create(model, user)
        # Check if a cart already exists for this person...
        existing_cart = model.where(user: user).first # Add first at the end to force DB hit

        # pause for a bit because we're busy doing something else...
        sleep(1)
        # insert a new row because we couldn't find any when we checked
        if existing_cart.blank?
          begin
            model.create!(user: user)
          rescue => e
            puts "creation failed with error #{e.message}"
          end
        end
      end

      def visible_puts(msg)
        puts "*"*100
        puts msg
        puts "*"*100
      end
    end
  end
end
