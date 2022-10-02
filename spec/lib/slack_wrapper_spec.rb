require 'rails_helper'

RSpec.describe SlackWrapper do
  it 'POSTs message to SLACK_WEBHOOK_URL' do
    response = double
    allow(HTTParty).to receive(:post).and_return(response)
    allow(response).to receive(:success?).and_return(true)
    wrapper = described_class.new.send_message!(channel: 'channel',
                                                bot_username: 'bot',
                                                text: 'Article')

    expect(HTTParty).to have_received(:post).with(ENV['SLACK_WEBHOOK_URL'],
                                                  body: { payload: { channel: '#channel',
                                                                     username: 'bot',
                                                                     text: 'Article' }.to_json })
    expect(wrapper).to eq response
  end

  it 'raises an error when sending a message to slack article channel fails' do
    response = double
    allow(HTTParty).to receive(:post).and_return(response)
    allow(response).to receive(:success?).and_return(false)
    allow(response).to receive(:body).and_return('some message')

    wrapper = described_class.new

    expect do
      wrapper.send_message!(channel: 'channel',
                            bot_username: 'bot',
                            text: 'New article: Title')
    end.to raise_error SlackWrapper::Error
  end
end
