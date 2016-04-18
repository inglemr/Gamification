class Test
  extend Resque::Plugins::History
  @queue = :background_queue
  def self.perform
    puts "Example"
  end
end
