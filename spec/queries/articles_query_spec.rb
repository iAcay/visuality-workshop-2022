require 'rails_helper'

xdescribe ArticlesQuery do
  it 'returns all articles when no filters are applied' do
    create(:article, title: 'First Article')
    create(:article, title: 'Second Article')

    results = described_class.new.results
    expect(results.pluck(:title)).to match_array ['First Article', 'Second Article']
  end

  describe 'filters' do
    it 'filters by article_id' do
      create(:article)
      second_article = create(:article)

      filters = { id: second_article.id }

      results = described_class.new(filter: filters).results

      expect(results.size).to eq 1
      expect(results.first).to eq second_article
    end

    it 'filters by title' do
      create(:article, title: 'How to train your dragon')
      second_article = create(:article, title: 'House of the Dragon')

      filters = { title: second_article.title }

      results = described_class.new(filter: filters).results

      expect(results.size).to eq 1
      expect(results.first).to eq second_article
    end

    it 'filters by content' do
      article1 = create(:article, content: 'How to train your dragon')
      article2 = create(:article, content: 'House of the Dragon')
      create(:article, content: 'Monsters Inc.')

      filters = { content: 'dragon' }

      results = described_class.new(filter: filters).results

      expect(results.size).to eq 2
      expect(results.map(&:id)).to match([article1.id, article2.id])
    end

    it 'filters by creation date' do
      old_article = create(:article, created_at: 1.week.ago)
      newer_article = create(:article, created_at: 4.days.ago)
      newest_article = create(:article, created_at: 1.day.ago)

      filters = { created_at_to: 6.days.ago.iso8601 }
      results = described_class.new(filter: filters).results

      expect(results.size).to eq 1
      expect(results.first).to eq old_article

      filters = { created_at_from: 2.days.ago.iso8601 }
      results = described_class.new(filter: filters).results

      expect(results.size).to eq 1
      expect(results.first).to eq newest_article

      filters = { created_at_from: 2.weeks.ago.iso8601, created_at_to: 3.days.ago.iso8601 }
      results = described_class.new(filter: filters).results

      expect(results.size).to eq 2
      expect(results.map(&:id)).to match([old_article.id, newer_article.id])
    end
  end

  describe 'sorting' do
    it 'sorts results by created_at, updated_at, title' do
      article1 = create(:article, created_at: 1.week.ago, updated_at: 5.days.ago, title: 'CCC')
      article2 = create(:article, created_at: 4.days.ago, updated_at: 1.day.ago, title: 'BBB')
      article3 = create(:article, created_at: 2.days.ago, updated_at: 2.days.ago, title: 'AAA')

      sort = { created_at: :desc }
      results = described_class.new(sort: sort).results

      expect(results.size).to eq 3
      expect(results.map(&:id)).to eq [article3.id, article2.id, article1.id]

      sort = { updated_at: :desc }
      results = described_class.new(sort: sort).results

      expect(results.size).to eq 3
      expect(results.map(&:id)).to eq [article2.id, article3.id, article1.id]

      sort = { title: :desc }
      results = described_class.new(sort: sort).results

      expect(results.size).to eq 3
      expect(results.map(&:id)).to eq [article1.id, article2.id, article3.id]
    end
  end
end
