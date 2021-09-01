module Examples
  class SelectForUpdate
    NAMES = ["James", "Mary"]

    def self.demo
      new.demo
    end

    def demo
      visible_puts("In this example, we simulate what happens if 2 different users try to access the same shared resource. James is here first so he's expected to get the coupon")
      Coupon.delete_all
      User.delete_all
      example_without_locking
      example_with_locking
      visible_puts("Selecting for update is useless unless used with a transaction")
      example_with_lock_without_transaction
    end

    def example_without_locking
      trigger_race_condition(with_lock: false, with_transaction: true)
    end

    def example_with_locking
      trigger_race_condition(with_lock: true, with_transaction: true)
    end

    def example_with_lock_without_transaction
      trigger_race_condition(with_lock: true, with_transaction: false)
    end

    def trigger_race_condition(with_lock:, with_transaction:)
      visible_puts("Race condition with lock #{ with_lock }, transaction #{ with_transaction }")
      coupon = Coupon.create!(state: :available)

      2.times.map do |t|
        user = User.create!(name: NAMES[t])
        Thread.new { redeem_coupon(user: user, with_lock: with_lock, with_transaction: with_transaction) }.tap do |t|
          sleep(0.1) # Because the second user comes in a bit later than the first one
        end
      end.each(&:join)
      user_name = coupon.reload.user.name
      visible_puts("coupon redeemed by #{ user_name }, #{ user_name == "James" ? "(Success)" : "(Fail)" }")
    end

    def redeem_coupon(user:, with_lock:, with_transaction:)
      if with_transaction
        Coupon.transaction { find_and_update_coupon(user: user, with_lock: with_lock) }
      else
        find_and_update_coupon(user: user, with_lock: with_lock)
      end
    end

    def find_and_update_coupon(user:, with_lock:)
      if with_lock
        coupon = Coupon.lock.find_by(state: :available)
      else
        coupon = Coupon.find_by(state: :available)
      end
      if coupon.present?
        visible_puts("Found coupon for #{ user.name }")
        sleep(1) # pause for a bit because we're busy doing something else...
        coupon.update!(user: user, state: :taken)
      else
        visible_puts("No more coupon, Ciao")
      end
    end

    def visible_puts(msg)
      puts "*"*100
      puts msg
      puts "*"*100
    end
  end
end
