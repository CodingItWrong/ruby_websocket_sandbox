require 'async/websocket/adapters/rack'
require 'pry'
require_relative 'connection_handler'
require_relative 'async_connection_adapter'

Handler = ConnectionHandler.new

AsyncApp = lambda {|env|
  Async::WebSocket::Adapters::Rack.open(env, protocols: ['ws']) do |connection|
    adapter = AsyncConnectionAdapter.new(connection)
    Handler.connected(adapter)

    while message = connection.read
      Handler.received(adapter, message)
    end
  ensure
    Handler.disconnected(adapter)
  end or [200, {}, ['Hello World']]
}
