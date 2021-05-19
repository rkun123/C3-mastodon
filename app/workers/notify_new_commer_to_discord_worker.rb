# frozen_string_literal: true

class NotifyNewCommerToDiscordWorker
  include Sidekiq::Worker
  include Redisable
  include Rails.application.routes.url_helpers

  def perform(account_id, discord_webhook_urls)
    client = Discordrb::Webhooks::Client.new(url: discord_webhook_urls)
    account = Account.find(account_id)

    puts account.avatar_remote_url

    builder = Discordrb::Webhooks::Builder.new(content: content(account), avatar_url: account.avatar_remote_url)
    client.execute(builder)
  end

  private

  def content(account)
    "Mastodonに新しく、#{account.username}が参加しました！\n#{account_url account}"
  end

  def account_url(account)
    "https://#{Rails.application.config.x.web_domain}#{account_path(account)}"
  end

end
