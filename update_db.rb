require_relative 'scraper'
require 'pg'

conn = PG.connect( dbname: 'data_gov_scraper_development')

scraper.topic_names.each do |name|
    conn.exec("INSERT INTO topics(name) VALUES('#{name}')")
end