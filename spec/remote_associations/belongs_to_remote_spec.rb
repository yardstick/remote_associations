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

    context 'generated attr_setter' do
      let(:remote_user) { RemoteUser.new(:id => 88) }

      it 'should assign the id of the remote object to the foreign key' do
        subject.user = remote_user
        expect(subject.user_id).to eq(88)
      end

      it 'should assign the value to the member variable' do
        subject.user = remote_user
        expect(subject.user).to eq(remote_user)
      end

      it 'should raise an error if there is a class mismatch' do
        expect{ subject.user = "Jimbob User" }.to raise_error RemoteAssociations::Errors::AssociationTypeMismatch
      end
    end
  end

  describe :has_remote_equivalent do # alias of belongs_to_remote
    subject { User.new.poker_user }

    # just want the happy path to ensure the alias is working
    it { should eq('bloop') }
  end
end
