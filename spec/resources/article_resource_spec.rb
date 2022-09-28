require 'rails_helper'

RSpec.describe ArticleResource do
  it 'returns serialised article with expected keys' do
    article = build(:article)
    expected_keys = [:title, :content]
    serialized_article = described_class.new(article).serializable_hash

    expect(serialized_article.keys).to match_array(expected_keys)
  end
end
