# README

A few examples of common concurrency issues and their possible answers with Rails/Postgres.

Everything lives in the "examples" folder [here](app/models/examples). It is suggested to go through them in order.
This is meant to be interactive and playing with the code is highly encouraged. Inserting `byebug` anywhere will give you a breakpoint -- [byebug](https://github.com/deivid-rodriguez/byebug)

Getting started:

* Ruby version: 2.7.2
* `bundle install`
* `bundle exec rake db:create`
* `bundle exec rake db:migrate`

Once the setup is complete, examples are meant to be run from a console like so:
* `rails c`
* `Examples::E1::SimpleTransaction.demo`
