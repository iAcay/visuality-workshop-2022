# frozen_string_literal: true

require 'json'
require 'httparty'

# POSTMAN CAPTURE REQUEST
#   OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
#   HTTParty::Basement.http_proxy("127.0.0.1", 5553, nil, nil)

class SlackWrapper
  Error = Class.new(StandardError)

  def initialize
    @webhook_url = ENV['SLACK_WEBHOOK_URL']
  end

  def send_message!(channel:, bot_username:, text:)
    payload = { channel: channel, username: bot_username, text: text }
    payload[:channel] = "##{payload[:channel]}" unless payload[:channel].start_with?('#')

    response = HTTParty.post(webhook_url, body: { payload: payload.to_json })
    raise Error.new(response.body) unless response.success?

    response
  rescue StandardError => e
    raise Error.new(e.message)
  end

  private

  attr_reader :webhook_url
end
