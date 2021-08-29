require_relative '../../lib/connection_handler'

RSpec.describe ConnectionHandler do
  let(:messages) { class_double(Message) }
  let(:conn) { double }

  subject(:handler) { ConnectionHandler.new(messages: messages) }

  context 'upon connection' do
    let(:message1) { double(contents: 'message 1') }
    let(:message2) { double(contents: 'message 2') }

    def perform!
      subject.connected(conn)
    end

    before do
      allow(messages).to receive(:all)
        .and_return([message1, message2])
    end

    it 'sends all past messages to the new connection' do
      expect(conn).to receive(:send)
        .with('message 1')
      expect(conn).to receive(:send)
        .with('message 2')
      perform!
    end
  end

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
