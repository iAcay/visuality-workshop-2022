require 'rails_helper'

describe ArticleCreationSlackNotificationJob do
  it 'call .send_message!' do
    article = create(:article, title: 'Title')
    slack_wrapper_double = instance_double(SlackWrapper, send_message!: nil)
    allow(SlackWrapper).to receive(:new).and_return(slack_wrapper_double)
    allow(slack_wrapper_double).to receive(:send_message!)

    described_class.new.perform(article.id)

    expect(SlackWrapper).to have_received(:new)
    expect(slack_wrapper_double).to have_received(:send_message!).with(channel: 'articles',
                                                                       bot_username: 'articles_bot',
                                                                       text: 'New article Title')
  end
end
