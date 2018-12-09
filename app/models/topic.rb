class Topic < ApplicationRecord
    has_many :articles

    def self.articles_per_topic
        articles_per_topic = Hash.new(0)
        Article.all.each{|article| articles_per_topic[article.topic_id] += 1}
        Topic.all.each do |topic|
            articles_per_topic[topic.name] = articles_per_topic.delete(topic.id)
        end
        return articles_per_topic.sort_by{|key, value| value}.reverse
    end


end
