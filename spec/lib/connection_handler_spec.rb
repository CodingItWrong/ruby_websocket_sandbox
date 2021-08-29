require_relative '../../lib/connection_handler'

RSpec.describe ConnectionHandler do
  let(:messages) { class_double(Message) }
  let(:conn) { double }

  subject(:handler) { ConnectionHandler.new(messages: messages) }

  context 'upon connection' do
    let(:other_conn) { double }
    let(:message1) { double(contents: 'message 1') }
    let(:message2) { double(contents: 'message 2') }

    def perform!
      subject.connected(conn)
      subject.connected(other_conn)
    end

    before do
      allow(messages).to receive(:all)
        .and_return([message1, message2])
      allow(other_conn).to receive(:send)
    end

    it 'sends all past messages to the new connection once' do
      expect(conn).to receive(:send)
        .with('message 1')
      expect(conn).to receive(:send)
        .with('message 2')
      perform!
    end
  end

  context 'when receiving a message' do
    let(:contents) { 'hello world' }
    let(:other_conn) { double }

    def perform!
      subject.connected(conn)
      subject.connected(other_conn)
      subject.received(conn, contents)
    end

    before do
      allow(messages).to receive(:all)
        .and_return([])
      allow(messages).to receive(:create!)
      allow(conn).to receive(:send)
      allow(other_conn).to receive(:send)
    end

    it 'saves the message' do
      expect(messages).to receive(:create!)
        .with(contents: contents)
      perform!
    end

    it 'sends the message to all connections' do
      message = "Response: #{contents}"
      expect(conn).to receive(:send).with(message)
      expect(other_conn).to receive(:send).with(message)
      perform!
    end
  end

  context 'after disconnecting' do
    let(:contents) { 'hello world' }
    let(:other_conn) { double }

    def perform!
      subject.connected(conn)
      subject.connected(other_conn)
      subject.disconnected(conn)
      subject.received(other_conn, contents)
    end

    before do
      allow(messages).to receive(:all)
        .and_return([])
      allow(messages).to receive(:create!)
      allow(other_conn).to receive(:send)
    end

    it 'does not send messages to the disconnected connection' do
      expect(conn).not_to receive(:send)
      perform!
    end
  end
end
