#Deadlock
class MyThread
  def initialize(mutex1,mutex2)
    @mutex1 = mutex1
    @mutex2 = mutex2
  end

  def execute
    @mutex1.synchronize do
      sleep(1)
      @mutex2.synchronize do
    end
    end
  end
end


mutex1 = Mutex.new
mutex2 = Mutex.new

m1 = MyThread.new(mutex1,mutex2)
m2 = MyThread.new(mutex2,mutex1)

t1 = Thread.new(m1) do |obj|
  obj.execute
end

t2 = Thread.new(m2) do |obj|
  obj.execute
end

t1.join
t2.join

