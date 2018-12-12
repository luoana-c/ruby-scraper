# README

This is a scraper which uses Nokogiri Ruby gem; The collected data is inserted into a Postgres db. Some statistics are displayed as a web page with Ruby on Rails and Chartkick

* Ruby version: 2.3.3

In order to run the scraper, and then set-up the database which feeds the Rails web app: 
* You need to have Ruby, Ruby on Rails and PostgreSQL installed
* If you have a different Ruby version installed, just comment out the Ruby version in the Gemfile

Other steps:
* bundle install
* rails db:create
* rails db:migrate
* ruby scraper.rb (it takes a while to finish)
* rails s and go to http://localhost:3000/statistics (or whichever port you selected)

This is how the statistics page looks like: 

