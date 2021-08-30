RSpec.describe 'ConnectionHandler integration', :db do
  let(:conn) { double('conn') }
  let(:other_conn) { double('other_conn') }

  let!(:message1) { Message.create!(contents: 'old message 1') }
  let!(:message2) { Message.create!(contents: 'old message 2') }

  subject(:handler) { ConnectionHandler.new }

  before do
    allow(conn).to receive(:send)
    allow(other_conn).to receive(:send)
  end

  it 'sends messages' do
    subject.connected(conn)
    subject.connected(other_conn)

    subject.received(conn, 'message from me')
    subject.received(other_conn, 'message from other')
    subject.received(conn, '')

    subject.disconnected(conn)

    subject.received(other_conn, 'message after disconnect')

    # connection while connected should receive past messages and all new
    # messages sent
    expect(conn).to have_received(:send).with('old message 1').ordered
    expect(conn).to have_received(:send).with('old message 2').ordered
    expect(conn).to have_received(:send).with('message from me').ordered
    expect(conn).to have_received(:send).with('message from other').ordered
    expect(conn).to have_received(:send).with("Validation failed: Contents can't be blank").ordered
    expect(conn).not_to have_received(:send).with('message after disconnect')
  end
end
