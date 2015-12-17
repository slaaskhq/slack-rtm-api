# Slack RTM Api

> Ruby wrapper for Slack RTM api

![Slack API Logo](https://slack.global.ssl.fastly.net/66f9/img/slack_api_logo.png)

## How it works?

1. Initialize a client with `client = SlackRTMApi::ApiClient.new client_token`, where the `client_token` is your client Slack token.

2. Bind websocket events and give them a callback.

3. Use `client.start`, this will start a new Thread, initialize the websocket, fetch for new events and call apropriates bindings

## How to use?

```rb
client = SlackRTMApi::ApiClient.new client_token

client.bind :message do |data|
  if data['type'] == 'message' && data['subtype'] != 'bot_message'
    p "Message: #{data['text']} by #{data['user']} in ##{data['channel']}"
  end
end

client.start

```

## Bind events

Available events are `open`, `message` and `error`, they all can be binded with the `client.bind` function like this:

```rb
client.bind :open do
end

```

```rb
client.bind :message do |data|
end

```

```rb
client.bind :error do |data|
end

```

## Options

#### Silenced mode

By default, the gem will log every connexion and events, you can remove those logs by passing `false` as a second argument in the `SlackRTMApi::ApiClient.new` function.

```rb
client = SlackRTMApi::ApiClient.new client_token, false
# client = SlackRTMApi::ApiClient.new client_token, Rails.env.production?

```
