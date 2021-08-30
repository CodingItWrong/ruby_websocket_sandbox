# frozen_string_literal: true

# NOTE: it's often not worth unit testing validation configuration of Active
# Record models. This is included as a confirmation of the fact that model tests
# work.
RSpec.describe Message, :db do
  context 'when contents are not blank' do
    subject { Message.new(contents: 'hello world') }
    it { should be_valid }
  end

  context 'when contents are blank' do
    subject { Message.new(contents: '') }
    it { should_not be_valid }
  end
end
