# frozen_string_literal: true

RSpec.describe ConnectionHandler do
  let(:messages) { class_double(Message) }
  let(:send_message_action) { instance_double(SendMessageAction) }
  let(:conn) { double }

  subject(:handler) {
    ConnectionHandler.new(
      messages: messages,
      send_message_action: send_message_action,
    )
  }

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

    it 'calls the action' do
      expect(send_message_action).to receive(:call)
        .with(connection: conn, data: contents)
      perform!
    end
  end

  context 'after disconnecting' do
    let(:contents) { 'hello world' }
    let(:other_conn) { double }
    let(:message1) { double(contents: 'message 1') }

    def perform!
      subject.connected(conn)
      subject.disconnected(conn)
      subject.connected(other_conn)
    end

    before do
      allow(messages).to receive(:all)
        .and_return([message1])
      allow(messages).to receive(:create!)
      allow(other_conn).to receive(:send)
    end

    it 'how to determine the connection is removed in a unit test??'
  end
end
