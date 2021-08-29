class AsyncConnectionAdapter
  def initialize(ws)
    @ws = ws
  end

  def send(message)
    ws.write(message)
    ws.flush
  end

  private

  attr_reader :ws
end
