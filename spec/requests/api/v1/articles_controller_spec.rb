require 'rails_helper'

RSpec.describe Api::V1::ArticlesController, type: :request do
  describe 'GET /api/v1/articles' do
    it 'returns all articles when there are no query params' do
      create(:article, title: 'First Article')
      create(:article, title: 'Second Article')

      get '/api/v1/articles'

      body = ActiveSupport::JSON.decode(response.body)

      articles_titles = body.map { |article| article['title'] }
      expect(articles_titles).to match_array ['First Article', 'Second Article']
      expect(response).to have_http_status(:ok)
    end

    it 'filters articles' do
      create(:article, title: 'BBB', content: 'How to train your dragon')
      create(:article, title: 'AAA', content: 'House of the Dragon')
      create(:article, content: 'Monsters Inc.')

      get '/api/v1/articles?filter[content]=dragon&sort[title]=asc'
      expect(response).to have_http_status(:ok)

      body = ActiveSupport::JSON.decode(response.body)
      expect(body.size).to eq 2

      articles_titles = body.map { |article| article['content'] }
      expect(articles_titles).to eq(['House of the Dragon', 'How to train your dragon'])
    end
  end

  describe 'POST /api/v1/articles' do
    it 'creates a new article' do
      article = build(:article, title: 'Title', content: 'Content')
      create_article_service_mock = instance_double(CreateArticleService)

      allow(CreateArticleService).to receive(:new).and_return(create_article_service_mock)

      allow(create_article_service_mock).to receive(:call).and_return(true)
      allow(create_article_service_mock).to receive(:article).and_return(article)

      params = { article: { title: 'Title', content: 'Content' } }
      post '/api/v1/articles', params: params

      body = ActiveSupport::JSON.decode(response.body)

      expect(body['article']['title']).to eq 'Title'
      expect(body['article']['content']).to eq 'Content'
      expect(response).to have_http_status(:ok)
      expect(CreateArticleService).to have_received(:new).with(title: 'Title', content: 'Content')
      expect(create_article_service_mock).to have_received(:call)
      expect(create_article_service_mock).to have_received(:article)
    end

    it 'fails when title is nil' do
      create_article_service_mock = instance_double(CreateArticleService)
      allow(CreateArticleService).to receive(:new).and_return(create_article_service_mock)

      allow(create_article_service_mock).to receive(:call).and_return(false)

      params = { article: { title: nil, content: nil } }
      post '/api/v1/articles', params: params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(CreateArticleService).to have_received(:new).with(title: nil, content: nil)
      expect(create_article_service_mock).to have_received(:call)
    end
  end
end
