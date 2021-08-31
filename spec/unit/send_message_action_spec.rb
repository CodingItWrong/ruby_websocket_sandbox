# frozen_string_literal: true

RSpec.describe SendMessageAction do
  let(:handler) { instance_double(ConnectionHandler) }
  let(:messages) { class_double(Message) }
  let(:conn) { double }

  subject(:action) {
    SendMessageAction.new(handler: handler, messages: messages)
  }

  context 'when receiving a valid message' do
    let(:contents) { 'hello world' }
    let(:other_conn) { double }

    def perform!
      subject.call(connection: conn, data: contents)
    end

    before do
      allow(messages).to receive(:all)
        .and_return([])
      allow(messages).to receive(:create!)
      allow(handler).to receive(:connections)
        .and_return([conn, other_conn])
      allow(conn).to receive(:send)
      allow(other_conn).to receive(:send)
    end

    it 'saves the message' do
      expect(messages).to receive(:create!)
        .with(contents: contents)
      perform!
    end

    it 'sends the message to all connections' do
      expect(conn).to receive(:send).with(contents)
      expect(other_conn).to receive(:send).with(contents)
      perform!
    end
  end

  context 'when receiving an invalid message' do
    let(:contents) { 'hello world' }
    let(:other_conn) { double }

    def perform!
      subject.call(connection: conn, data: contents)
    end

    before do
      allow(messages).to receive(:all)
        .and_return([])
      allow(messages).to receive(:create!)
        .and_raise(RuntimeError.new('foof'))
      allow(handler).to receive(:connections)
        .and_return([conn, other_conn])
      allow(conn).to receive(:send)
    end

    it 'sends the error message to the sender only' do
      message = 'foof'
      expect(conn).to receive(:send).with(message)
      expect(other_conn).not_to receive(:send)
      perform!
    end
  end
end
