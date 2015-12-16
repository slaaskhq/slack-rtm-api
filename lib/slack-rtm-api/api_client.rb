require 'json'
require 'socket'
require 'websocket/driver'
require 'logger'

module SlackRTMApi

  class ApiClient
    VALID_DRIVER_EVENTS = [:open, :message, :error]
    BASE_URL            = 'https://slack.com/api'
    RTM_START_PATH      = '/rtm.start'

    def initialize(token, silent = true)
      @logger     = logger = Logger.new(STDOUT) unless silent
      @token      = token
      @silent     = silent
      @ready      = false
      @connected  = false

      if token.nil?
        raise ArgumentError.new "You should pass a valid RTM Websocket url"
      else
        @url = get_ws_url
      end

      @event_handlers = {}
      @events_queue   = []
    end

    def bind(type, &block)
      unless VALID_DRIVER_EVENTS.include? type
        raise ArgumentError.new "The event `#{type}` doesn't exist, available events are: #{VALID_DRIVER_EVENTS}"
      end

      @event_handlers[type] = block
    end

    def send(event)
      event[:id] = random_id
      @events_queue << event.to_json
    end

    def init
      return if @ready

      @socket = OpenSSL::SSL::SSLSocket.new TCPSocket.new(@url.host, 443)
      @socket.connect

      @driver = WebSocket::Driver.client SlackRTMApi::ClientWrapper.new(@url.to_s, @socket)

      @driver.on :open do
        @connected = true
        send_log "WebSocket::Driver is now connected"
        @event_handlers[:open].call unless @event_handlers[:open].nil?
      end

      @driver.on :error do |event|
        @connected = false
        send_log "WebSocket::Driver recieved an error"
        @event_handlers[:error].call unless @event_handlers[:error].nil?
      end

      @driver.on :message do |event|
        data = JSON.parse event.data
        send_log "WebSocket::Driver recieved an event with data: #{data}"
        @event_handlers[:message].call data unless @event_handlers[:message].nil?
      end

      @driver.start

      @ready = true
    end

    def check_ws
      data = @socket.readpartial 4096

      return if data.nil? or data.empty?

      @driver.parse data

      handle_events_queue
    end

    def handle_events_queue
      @events_queue.each do |event|
        send_log "WebSocket::Driver send #{event}"
        @driver.text event
      end

      @events_queue.clear
    end

    def start
      t = Thread.new do
        init
        loop do
          check_ws
        end
      end

      t.abort_on_exception = true
    end

    private

    def get_ws_url
      req   = Net::HTTP.post_form URI(BASE_URL + RTM_START_PATH), token: @token
      body  = JSON.parse req.body
      if body['ok']
        URI body['url']
      else
        raise ArgumentError.new "Slack error: #{body['error']}"
      end
    end

    def send_log(log)
      @logger.info(log) unless @silent
    end

    def random_id
      SecureRandom.random_number 9999999
    end
  end

end
