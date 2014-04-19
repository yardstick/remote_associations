require 'spec_helper'

describe RemoteAssociations do
  describe :belongs_to_remote do
    subject { Comment.new(:user_id => 99) } # Wayne Gretzky
    it 'should just return the result of the block when invoked' do
      subject.auth_token = "FRANK"
      expect(subject.post_uses_token).to eq "FRANK"
    end

    it 'should raise an error when called without setting token first' do
      expect{ subject.post_uses_token }.to raise_error(RemoteAssociations::Errors::MissingTokenError)
    end

    context 'generated attr_reader' do
      before do
        RemoteUser.expects(:find).once.with(:token, 99).returns(:the_user_record_from_remote_service)
      end

      it 'should by default (when no block defined) call find for the record' do
        expect(subject.user(:token)).to eq(:the_user_record_from_remote_service)
      end

      it 'should memoize for subsequent calls' do
        subject.user(:token)
        expect(subject.user).to eq(:the_user_record_from_remote_service)
      end
    end
  end

  describe :has_remote_equivalent do # alias of belongs_to_remote
    subject { User.new.poker_user }

    # just want the happy path to ensure the alias is working
    it { should eq('bloop') }
  end
end
