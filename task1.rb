class Producer
  def initialize(queue,mutex,conditional,name)
    @queue = queue
    @mutex = mutex
    @conditional = conditional
    @name = name
  end

  def execute
      while true
      @mutex.synchronize do
        while @queue.size >=5
          @conditional.wait(@mutex)
        end
        @queue.eng("object")
        puts "Producer " + @name + "put the object"
        @conditional.broadcast
      end
      sleep(2)
      end
  end
end

class Consumer
  def initialize(queue,mutex,conditional,name)
    @queue = queue
    @mutex = mutex
    @conditional = conditional
    @name = name
  end

def execute
  while true
    @mutex.synchronize do
      while @queue.size ==0
        @conditional.wait(@mutex)
      end
      @queue.deq("object")
      puts "Consumer " + @name + "take the object"
      @conditional.broadcast
    end
    sleep(2)
    end
  end
end

queue = SizedQueue.new(5)
mutex = Mutex.new
conditional = ConditionVariable.new

t1 = Producer.new(queue, mutex, conditional,"t1")
t2 = Producer.new(queue, mutex, conditional,"t2")

t3 = Consumer.new(queue, mutex, conditional,"t3")
t4 = Consumer.new(queue, mutex, conditional,"t4")
t5 = Consumer.new(queue, mutex, conditional,"t5")

Thread.new(t1) do|obj|
  obj.execute
end
Thread.new(t2) do|obj|
  obj.execute
end
Thread.new(t3) do|obj|
  obj.execute
end
Thread.new(t4) do|obj|
  obj.execute
end
Thread.new(t5) do|obj|
  obj.execute
end
t1.join
t2.join
t3.join
t4.join
t5.join