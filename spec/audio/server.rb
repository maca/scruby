class Scruby::Audio::Server
  attr_reader :output
  def puts string
    @output ||= ""
    @output << string
    string
  end
  
  def flush
    @output = ''
  end
end