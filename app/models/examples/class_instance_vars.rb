module Examples
  class ClassInstanceVars
    def self.demo
      new.demo
    end

    def demo
      visible_puts("In this example, we demonstrate that class instance variables are not thread safe in Ruby")
      example
    end

    def example
      2.times.map do |thread_num|
        # Imagine these are 2 web requests hitting your server
        Thread.new { perform_example(thread_num) }.tap do
          sleep(0.1)
        end
      end.each(&:join)
    end

    def perform_example(thread_num)
      var_value = "something set from thread #{ thread_num }"
      visible_puts("From thread #{ thread_num }, setting var to #{ var_value }")
      ExampleClass.assign_variable(var_value)
      sleep(1) # Because we're doing something else
      retrieved_var = ExampleClass.retrieve_var
      correct_value = retrieved_var.last.to_i == thread_num
      visible_puts("From thread #{ thread_num }, variable retrieved, value: #{ retrieved_var }, correct_value: #{ correct_value }")
    end

    def visible_puts(msg)
      puts "*"*100
      puts msg
      puts "*"*100
    end
  end

  class ExampleClass
    def self.assign_variable(value)
      @example_variable = value
    end

    def self.retrieve_var
      @example_variable
    end
  end
end

