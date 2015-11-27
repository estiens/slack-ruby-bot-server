require 'service'

Mongoid.load! File.expand_path('../../config/mongoid.yml', __FILE__), ENV['RACK_ENV']

def logger
  @logger ||= begin
    $stdout.sync = true
    Logger.new(STDOUT)
  end
end

Thread.abort_on_exception = true

Thread.new do
  begin
    EM.run do
      SlackRubyBot::Service.start_from_database!
    end
  rescue StandardError => e
    logger.error e
    raise e
  end
end
