require_relative '../../lib/connection_handler'

RSpec.describe ConnectionHandler do
  let(:messages) { class_double(Message) }
  let(:conn) { double }

  subject(:handler) { ConnectionHandler.new(messages: messages) }

  context 'when there are no previous messages' do
    let(:contents) { 'hello world' }

    def perform!
      subject.connected(conn)
      subject.received(conn, contents)
    end

    before do
      allow(messages).to receive(:all)
        .and_return([])
      allow(messages).to receive(:create!)
      allow(conn).to receive(:send)
    end

    it 'saves the message' do
      expect(messages).to receive(:create!)
        .with(contents: contents)
      perform!
    end

    it 'replies with messages sent' do
      expect(conn).to receive(:send)
        .with("Response from Faye: #{contents}")
      perform!
    end
  end
end
