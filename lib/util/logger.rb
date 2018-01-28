require 'logger'

module Dorothy::Util
  
  class Logger
    
    def initialize(command)
      @log_file = "logs/#{command.to_s}.log"
    end

  end

end