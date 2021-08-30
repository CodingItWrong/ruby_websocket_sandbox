RSpec.describe 'ConnectionHandler integration', :db do
  let(:conn) { double('conn') }

  subject(:handler) { ConnectionHandler.new }

  context 'upon connection' do
    let(:other_conn) { double }
    let!(:message1) { Message.create!(contents: 'message 1') }
    let!(:message2) { Message.create!(contents: 'message 2') }

    def perform!
      subject.connected(conn)
      subject.connected(other_conn)
    end

    before do
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
    let(:other_conn) { double('other_conn') }

    def perform!
      subject.connected(conn)
      subject.connected(other_conn)
      subject.received(conn, contents)
    end

    before do
      allow(conn).to receive(:send)
      allow(other_conn).to receive(:send)
    end

    it 'saves the message' do
      perform!
      expect(Message.count).to eq(1)
      expect(Message.first.contents).to eq(contents)
    end

    it 'sends the message to all connections' do
      message = "Response: #{contents}"
      expect(conn).to receive(:send).with(message)
      expect(other_conn).to receive(:send).with(message)
      perform!
    end
  end

  context 'when receiving an empty message' do
    let(:other_conn) { double('other_conn') }

    def perform!
      subject.connected(conn)
      subject.connected(other_conn)
      subject.received(conn, '')
    end

    before do
      allow(conn).to receive(:send)
    end

    it 'sends the error message to the sender only' do
      error = "Validation failed: Contents can't be blank"
      expect(conn).to receive(:send).with(error)
      expect(other_conn).not_to receive(:send)
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
      allow(other_conn).to receive(:send)
    end

    it 'does not send messages to the disconnected connection' do
      expect(conn).not_to receive(:send)
      perform!
    end
  end
end
