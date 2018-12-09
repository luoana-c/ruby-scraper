require 'nokogiri'
require 'open-uri'
require 'pg'

conn = PG.connect( dbname: 'data_gov_scraper_development')

main_page = Nokogiri::HTML(open('https://data.gov.uk/'))

topic_a = main_page.css('div.column-one-third a')
topic_base_links = topic_a.map {|link| "https://data.gov.uk#{link['href']}"}
topic_names = topic_a.map {|link| link.text}

topic_names.each do |name|
    conn.exec("INSERT INTO topics(name) VALUES('#{name}')")
end


first_topic_base_html = Nokogiri::HTML(open(topic_base_links[0]))

first_topic_num_articles = first_topic_base_html.css('.bold-small').text.tr(',', '').to_i
first_topic_num_pages = first_topic_num_articles % 20 == 0 ? first_topic_num_articles / 20 : first_topic_num_articles / 20 + 1
first_topic_all_links = (2..first_topic_num_pages).map {|page_number| "#{topic_base_links[0]}&page=#{page_number}"}
first_topic_all_links.unshift(topic_base_links[0])


# for all pages of all topics

topic_base_links.each_with_index do |base_link, index|
    topic_base_html = Nokogiri::HTML(open(base_link))
    topic_num_articles = topic_base_html.css('.bold-small').text.tr(',', '').to_i
    topic_num_pages = topic_num_articles % 20 == 0 ? topic_num_articles / 20 : topic_num_articles / 20 + 1

    topic_all_links = (2..topic_num_pages).map {|page_number| "#{base_link}&page=#{page_number}"}
    topic_all_links.unshift(base_link)
    

    topic_all_links_articles = []
    topic_all_links_article_title = []
    topic_all_links_article_published_by = []
    topic_all_links_article_last_updated = []

    topic_all_links.each do |link|
        page_html = Nokogiri::HTML(open(link))
      
        page_html.css('div.dgu-results__result').each do |article|
            topic_all_links_articles << article
        end
    end

    topic_all_links_articles.each do |article|
        topic_all_links_article_title << article.css('a').text.gsub("'", "''")
        topic_all_links_article_published_by << article.css('.published_by').text.gsub("'", "\'\'")
        topic_all_links_article_last_updated << article.css('.last_updated').text.gsub("'", "\'\'")
    end

    (0..topic_all_links_article_title.length - 1).each do |row|
        begin
            sqlQuery = "
            INSERT INTO articles(title, publisher, last_updated, topic_id) 
            VALUES('#{topic_all_links_article_title[row]}', 
                   '#{topic_all_links_article_published_by[row]}',
                   '#{topic_all_links_article_last_updated[row]}',
                   '#{index + 1}')"
            conn.exec(sqlQuery)
        rescue
            puts row
            puts "#{topic_all_links_article_title[row]} - #{topic_all_links_article_published_by[row]} - #{topic_all_links_article_last_updated[row]}"
            puts sqlQuery
            raise "error"
        end
    end
end

# VALUES(' Bob's Burgers ')

# topic_base_html_arr = topic_base_links.map {|link| Nokogiri::HTML(open(link))}
# num_articles_arr = topic_base_html_arr.map {|html| html.css('.bold-small').text.tr(',', '').to_i}
# num_pages_arr = num_articles_arr.map {|num| num % 20 == 0 ? (num / 20) : (num / 20 + 1)}


# FOR all pages of first topic: 

# first_topic_all_links_articles = []
# first_topic_all_links_article_title = []
# first_topic_all_links_article_published_by = []
# first_topic_all_links_article_last_updated = []

# first_topic_all_links.each do |link|
#     page_html = Nokogiri::HTML(open(link))
      
#     page_html.css('div.dgu-results__result').each do |article|
#         first_topic_all_links_articles << article
#     end
# end

# first_topic_all_links_articles.each do |article|
#     first_topic_all_links_article_title << article.css('a').text
#     first_topic_all_links_article_published_by << article.css('.published_by').text
#     first_topic_all_links_article_last_updated << article.css('.last_updated').text
# end




# for each page in first_topic_all_links: 
# 1. get the html
# 2. .css('div.dgu-results__result')

# FOR ONE PAGE OF FIRST TOPIC: 
# first_topic_article_list = first_topic_base_html.css('div.dgu-results__result')

# first_topic_article_names = first_topic_article_list.css('a').map {|title| title.text}

# first_topic_article_published_by = first_topic_article_list.css('.published_by').map {|pub_by| pub_by.text}

# first_topic_last_updated = first_topic_article_list.css('.last_updated').map {|date| date.text}










