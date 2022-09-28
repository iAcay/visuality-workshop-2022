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

    xit 'filters articles' do
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
end
