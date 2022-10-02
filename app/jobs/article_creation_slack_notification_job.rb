class ArticleCreationSlackNotificationJob
  include Sidekiq::Job

  def perform(article_id)
    article = Article.find(article_id)

    SlackWrapper.new.send_message!(channel: 'articles',
                                   bot_username: 'articles_bot',
                                   text: "New article #{article.title}")
  end
end
