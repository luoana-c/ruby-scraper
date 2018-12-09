class StatisticsController < ApplicationController
    def index
        @topics = Topic.all
        @articles = Article.all
        @articles_per_topic = Topic.articles_per_topic
        @articles_per_publisher = Hash[Article.articles_per_publisher.sort_by{|k, v| -v}[0..9]]
        # @articles_per_last_updated = Article.all.group_by_year(:last_updated).count
    end 
 
end
