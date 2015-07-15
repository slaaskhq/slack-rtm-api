module SlackRTMApi
  class ClientWrapper
    attr_accessor :url, :socket

    def initialize(url, socket)
      @url    = url
      @socket = socket
    end

    def write(*args)
      self.socket.write(*args)
    end
  end
end
