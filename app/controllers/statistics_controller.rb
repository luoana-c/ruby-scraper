class StatisticsController < ApplicationController
    def index
        @topics = Topic.all
        @articles = Article.all
        @articles_per_topic = Topic.articles_per_topic
        @articles_per_publisher = Hash[Article.articles_per_publisher.sort_by{|k, v| -v}[0..9]]
        @publishers = Article.publishers
    end 
end
