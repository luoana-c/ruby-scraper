require 'nokogiri'
require 'open-uri'
require 'pg'


main_page = Nokogiri::HTML(open('https://data.gov.uk/'))

topic_a = main_page.css('div.column-one-third a')
topic_base_links = topic_a.map {|link| "https://data.gov.uk#{link['href']}"}
topic_names = topic_a.map {|link| link.text}

conn = PG.connect( dbname: 'data_gov_scraper_development')

puts "Inserting topic names into the db..."

topic_names.each do |name|
    conn.exec("INSERT INTO topics(name) VALUES('#{name}')")
end

topic_base_links.each_with_index do |base_link, index|
    topic_name = base_link[46..-1].gsub("+", " ")
    topic_base_html = Nokogiri::HTML(open(base_link))
    topic_num_articles = topic_base_html.css('.bold-small').text.gsub(",", "").to_i
    topic_num_pages = topic_num_articles % 20 == 0 ? topic_num_articles / 20 : topic_num_articles / 20 + 1    

    topic_all_links_articles = []
    topic_all_links_article_title = []
    topic_all_links_article_published_by = []
    topic_all_links_article_last_updated = []

    puts "#{index + 1}a. Collecting data for all pages of #{topic_name}..."

    (1..topic_num_pages).each do |page|
        page_link = page == 1 ? base_link : "#{base_link}&page=#{page}"
        
        page_html = Nokogiri::HTML(open(page_link))
        page_html.css('div.dgu-results__result').each do |article|
            topic_all_links_article_title << article.css('a').text.gsub("'", "''")
            topic_all_links_article_published_by << article.css('.published_by').text.gsub("'", "\'\'")
            topic_all_links_article_last_updated << article.css('.last_updated').text.gsub("'", "\'\'")
        end

    end

    puts "#{index + 1}b. Inserting all data collected from #{topic_name} into the db..."

    (0..topic_all_links_article_title.length - 1).each do |row|   
        sqlQuery = "
        INSERT INTO articles(title, publisher, last_updated, topic_id) 
        VALUES('#{topic_all_links_article_title[row]}', 
                '#{topic_all_links_article_published_by[row]}',
                '#{topic_all_links_article_last_updated[row]}',
                '#{index + 1}')"
        conn.exec(sqlQuery)
    end
end

puts "Done"

