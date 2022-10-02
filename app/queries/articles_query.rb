class ArticlesQuery
  def initialize(params = {})
    @params = params
  end

  def results
    prepare_collection
    filter_by_id
    filter_by_title
    filter_by_content
    filter_by_creation_date
    sorting
    @results
  end

  private

  def prepare_collection
    @results = Article.all
  end

  def filter_by_id
    return if @params.dig(:filter, :id).blank?

    @results = @results.where(id: @params.dig(:filter, :id))
  end

  def filter_by_title
    return if @params.dig(:filter, :title).blank?

    @results = @results.where(title: @params.dig(:filter, :title))
  end

  def filter_by_content
    return if @params.dig(:filter, :content).blank?

    @results = @results.where('articles.content ILIKE ?', "%#{@params.dig(:filter, :content)}%")
  end

  def filter_by_creation_date
    scope_to = @params.dig(:filter, :created_at_to)
    scope_from = @params.dig(:filter, :created_at_from)

    return if scope_to.blank? && scope_from.blank?

    @results = @results.where(created_at: scope_from..scope_to)
  end

  def sorting
    return if @params[:sort].blank?

    sort = [@params[:sort].keys.first, @params[:sort].values.first].join(' ')

    @results = @results.order(Arel.sql(sort))
  end
end
