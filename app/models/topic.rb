class Topic < ApplicationRecord
    has_many :articles

    def articles_per_topic
        Article.all.count{|article| article.topic_id == self.id}
    end


end
