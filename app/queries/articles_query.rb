class ArticlesQuery
  def initialize(params = {})
    @params = params
  end

  def results
    prepare_collection

    @results
  end

  private

  def prepare_collection
    @results = Article.all
  end
end
