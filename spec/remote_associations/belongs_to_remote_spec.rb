require 'spec_helper'

describe RemoteAssociations do
  describe :belongs_to_remote do
    subject { Comment.new }
    it 'should just return the result of the block when invoked' do
      subject.auth_token = "FRANK"
      expect(subject.post_uses_token).to eq "FRANK"
    end

    it 'should raise an error when called without setting token first' do
      expect{ subject.post_uses_token }.to raise_error(RemoteAssociations::Errors::MissingTokenError)
    end

    it 'should raise an error when called and no fetch block is declared' do
      expect{ subject.user_missing_block }.to raise_error(RemoteAssociations::Errors::MissingFetchBlockError)
    end
  end
end
