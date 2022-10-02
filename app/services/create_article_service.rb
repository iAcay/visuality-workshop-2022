class CreateArticleService
  attr_reader :article, :errors

  def initialize(title:, content:)
    @title = title
    @content = content
    @errors = []
  end

  def call
    @article = Article.new(title: @title, content: @content)

    return failure(@article.errors.full_messages) unless @article.save

    ArticleCreationSlackNotificationJob.perform_async(@article.id)

    true
  end

  private

  def failure(message)
    @errors << message
    false
  end
end
