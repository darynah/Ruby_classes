#сервер
require 'socket'

class ClientHandler
  def initialize(client_sock)
    @client_sock = client_sock
  end

  def execute
    message = @client_sock.gets.to_s.chop
    message += "from_server"
    @client_sock.puts(message)
    @client_sock.close
  end
end

server = TCPServer.new('0.0.0.0', 5555)
while true
  client_sock = server.accept #блокирует сервер пока клиент не создаст запрос на соединение
  client_handler = ClientHandler.new(client_sock)
  t = Thread.new(client_handler) do |handler|
    handler.execute
  end

end
