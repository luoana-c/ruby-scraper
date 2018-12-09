class Article < ApplicationRecord
    belongs_to :topic

    def self.publishers
        publishers = []
        Article.all.each do |article|
            if !publishers.include?(article.publisher)
                publishers << article.publisher
            end
        end
        return publishers
    end

    def self.articles_per_publisher
        articles_per_publisher = Hash.new(0)
        Article.all.each {|article| articles_per_publisher[article.publisher] += 1}
        
        return articles_per_publisher.sort_by{|key, value| value}.reverse.to_h
    end

    def self.articles_last_updated
        # articles_last_updated = {}
        # Article.all.each {|article| articles_last_updated[article.title] = article.last_updated}
        
        articles_last_updated = Hash.new(0)
        Article.all.each {|article| articles_last_updated[article.last_updated] += 1}
        return articles_last_updated
    end
end
