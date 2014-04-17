require 'spec_helper'

describe RemoteAssociations::ActiveRecord::RelationExtensions do
  let(:post_id) { 4 }
  let(:comment1) { Comment.new(post_id: post_id) }
  let(:comment2) { Comment.new(post_id: comment1.post_id) }
  let(:records) { [comment1, comment2] }
  let(:remote_post) { RemotePost.new(id: comment1.post_id) }

  subject { RemoteAssociations::Relation.new(records) }

  describe :includes_remote do
     it 'should put the association name in the remote includes list' do
      expect(subject.includes_remote(:post).remote_preloads).to include :post
    end
  end

  describe :joins_remote do
    let(:token) { 'token' }

    it 'should not include items that are associated with a remote model that is not accessible' do
      RemotePost.expects(:all).with(token, ids: [comment1.post_id]).returns([])
      results = subject.joins_remote(:post).auth_token(token).exec_queries
      expect(results).to be_empty
    end

    it 'should be fine if the thing is actually in the remote list' do
      RemotePost.expects(:all).with(token, ids: [comment1.post_id]).returns([remote_post])
      results = subject.joins_remote(:post).auth_token(token).exec_queries
      expect(results).to include(comment1)
      expect(results).to include(comment2)
    end
  end

  describe :exec_queries do
    let(:token) { '1235' }

    it 'should ask the class to load the records' do
      RemotePost.expects(:all).with(token, ids: [comment1.post_id]).returns([remote_post])
      subject.includes_remote(:post).auth_token(token).exec_queries.each do |comment|
        expect(comment.post).to eq remote_post
      end
    end

    it 'should still work (no nil pointer errors) if the relationship is orphaned' do
      RemotePost.expects(:all).with(token, ids: [comment1.post_id]).returns([])
      subject.includes_remote(:post).auth_token(token).exec_queries.each do |comment|
        expect { comment.post }.to raise_error RemoteAssociations::Errors::MissingFetchBlockError
      end
    end
  end
end
