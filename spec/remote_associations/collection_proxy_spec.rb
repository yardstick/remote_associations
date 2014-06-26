require 'spec_helper'

describe RemoteAssociations::CollectionProxy do
  let(:comment_attributes) do
    3.times.map do |i|
      { :post_id => Id.generate, :user_id => Id.generate }
    end
  end

  subject do
    RemoteAssociations::CollectionProxy.new(Comment) { comment_attributes }
  end

  describe :includes_remote do
    let(:token) { 'whatever' }

    it 'should try to preload the remote records' do
      RemoteUser.expects(:find).never
      records = subject.includes_remote(:user).auth_token(token).records
      expect(records.length).to eq(3)
      3.times do |i|
        expect(records[i].user.id).to eq(comment_attributes[i][:user_id])
      end
    end
  end

  describe :joins_remote do
    let(:token) { 'something' }

    it 'should also preload the remote records' do
      remote_post = RemotePost.new(:id => comment_attributes.last[:post_id])
      RemotePost.expects(:find).never
      RemotePost.expects(:all).with(token, :ids => comment_attributes.map { |x| x[:post_id] }).returns([remote_post])
      records = subject.joins_remote(:post).auth_token(token).records
      expect(records.length).to eq(1)
      records.each do |r|
        expect(r.post_id).to eq(comment_attributes.last[:post_id])
      end
    end
  end

  describe :records do
    let(:token) { 'be a token' }

    it 'should recall the block if an association is included' do
      RemoteUser.expects(:find).never

      subject.records

      comment_attributes << { :post_id => Id.generate, :user_id => Id.generate }

      records = subject.includes_remote(:user).auth_token(token).records
      expect(records.length).to eq(4)
    end
  end

  describe :== do
    it 'should compare internal object collections of each other' do
      other = RemoteAssociations::CollectionProxy.new(Comment) { comment_attributes }
      expect(other).to eq(subject)
      expect(subject).to eq(other)
    end
  end
end
