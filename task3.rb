#3 скрипки+ 3 смычка + 6 скрипачей

class Violinist
  def initialize(queue_violin, mutex_violin, cond_violin, queue_bow, mutex_bow, cond_bow, name)
    @queue_violin = queue_violin
    @mutex_violin = mutex_violin
    @cound_violin = cond_violin
    @queue_bow = queue_bow
    @mutex_bow = mutex_bow
    @cond_bow = cond_bow
    @name = name
  end

  def play
    violin = nil
    bow = nil
    while true
      @mutex_violin.synchronize do
        while @queue_violin.size == 0
          @cound_violin.wait (@mutex_violin)
        end
        violin = @queue_violin.deq
        puts "The violinist " + @name +"take the violin"
      end
      @mutex_bow.synchronize do
        while @queue_bow.size == 0
          @cond_bow.wait(@mutex_bow)
        end
        bow = @queue_bow.deq
        puts "The violinist " + @name+ "take the bow"
      end
      puts "Violinist " + @name + "is playing"
      sleep(5)

      @mutex_violin.synchronize do
        @queue_violin.enq(violin)
        @cond_violin.broadcast
      end
      puts "Violinist " + @name+ "return the violin"

      @mutex_bow.synchronize do
        @queue_bow.enq(bow)
        @cond_bow.broadcast
      end
      puts "Violinist " + @name + "return the bow"
      sleep(2)
    end
  end
end

queue_violin = SizedQueue.new(2)
mutex_violin = Mutex.new
cond_violin = ConditionVariable.new
queue_violin.enq("violin1")
queue_violin.enq("violin2")

queue_bow = SizedQueue.new(2)
mutex_bow = Mutex.new
cond_bow = ConditionVariable.new
queue_bow.enq("bow1")
queue_bow.enq("bow2")

v1 = Violinist.new(queue_violin, mutex_violin, cond_violin, cond_bow, mutex_violin, mutex_bow, "v1")
v2 = Violinist.new(queue_violin, mutex_violin, cond_violin, cond_bow, mutex_violin, mutex_bow, "v2")
v3 = Violinist.new(queue_violin, mutex_violin, cond_violin, cond_bow, mutex_violin, mutex_bow, "v3")
v4 = Violinist.new(queue_violin, mutex_violin, cond_violin, cond_bow, mutex_violin, mutex_bow, "v4")

t1 = Thread.new(v1) do |obj|
  obj.play
end

t2 = Thread.new(v1) do |obj|
  obj.play
end

t3 = Thread.new(v1) do |obj|
  obj.play
end

t4 = Thread.new(v1) do |obj|
  obj.play
end

t1.join
t2.join
t3.join
t4.join