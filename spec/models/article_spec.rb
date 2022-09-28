require 'rails_helper'

RSpec.describe Article, type: :model do
  it 'is valid with an unique title' do
    article = build(:article, title: 'A title')
    expect(article).to be_valid
  end

  it 'is invalid without a title' do
    article = build(:article, title: nil)
    expect(article).not_to be_valid
  end

  it 'is invalid when the title is not unique' do
    create(:article, title: 'A title')
    article = build(:article, title: 'A title')
    expect(article).not_to be_valid
  end

  it 'is invalid when the content is empty' do
    article = build(:article, title: 'A title', content: nil)
    expect(article).not_to be_valid
  end
end
