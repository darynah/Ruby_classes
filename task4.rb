#клиент

require 'socket'
sock = TCPSocket.new('127.0.0.1',5555)
message = "Hello server "
sock.puts message

answer = sock.gets
puts answer
sock.close