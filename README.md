# Slack RTM Api

> Ruby wrapper for Slack RTM api

![Slack API Logo](https://slack.global.ssl.fastly.net/66f9/img/slack_api_logo.png)

## How it works?

1. Initialize a client with `client = SlackRTMApi::ApiClient.new(token: client_token)`, where the `client_token` is your client Slack token.

2. Bind websocket events and give them a callback.

## How to use?

```rb
client = SlackRTMApi::ApiClient.new(token: client_token)

client.bind :message do |data|
  if data['type'] == 'message' && data['subtype'] != 'bot_message'
    p "Message: #{data['text']} by #{data['user']} in ##{data['channel']}"
  end
end

client.start

```

## Bind events

Available events are `open`, `close`, `message` and `error`, they all can be bound with the `client.bind` function like this:

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

#### Debug logging

By default, the gem is silent, however debugging output can be enabled using the `debug: true` option when declaring a new instance, which enables logging to STDOUT via Logger.

```rb
client = SlackRTMApi::ApiClient.new(token: client_token, debug: true)
```

#### Auto-start mode

By default, declaring a new instance of ApiClient will also initiate the connection to Slack.  If this is not desired behavior, use `auto_start: false` when declaring a new instance.  The timeout before returning if the connection cannot be made is adjustable with the open_wait_timeout options, which defaults to 15 seconds.

```rb
client = SlackRTMApi::ApiClient.new(token: client_token, auto_start: false)
# -or-
client = SlackRTMApi::ApiClient.new(token: client_token, open_wait_timeout: 5)
```

#### Auto-reconnect mode

SlackRTMApi tracks Slack `reconnect_url` messages, and constantly updates it's internal URL with these periodic messages.  By default, SlackRTMApi will then use the last broadcast URL in order to initiate a reconnect in the case of connection failure.  This behavior can be overidden by using `auto_reconnect: false`

```rb
client = SlackRTMApi::ApiClient.new(token: client_token, auto_reconnect: false)
```

#### WebSocket Ping/Pong

SlackRTMApi uses client-initiated [WebSocket Keepalive Ping/Pongs](https://tools.ietf.org/html/rfc6455#section-5.5.2) in order to more quickly realize a broken connection. By default, Ping packets are sent when there is no activity for 15 seconds.  This threshold can be configured by using the `ping_threshold: ##` option.

```rb
client = SlackRTMApi::ApiClient.new(token: client_token, ping_threshold: 600)
```
