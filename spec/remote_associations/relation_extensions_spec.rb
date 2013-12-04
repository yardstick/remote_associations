require 'spec_helper'

describe RemoteAssociations::ActiveRecord::RelationExtensions do
  let(:post_id) { 4 }
  let(:comment1) { Comment.new(post_id: post_id) }
  let(:comment2) { Comment.new(post_id: comment1.post_id) }
  let(:records) { [comment1, comment2] }

  subject { RemoteAssociations::Relation.new(records).includes_remote(:post) }

  describe :includes_remote do
     it 'should put the association name in the remote includes list' do
      expect(subject.remote_preloads).to include :post
    end
  end

  describe :exec_queries do
    let(:remote_post) { RemotePost.new(id: comment1.post_id) }
    let(:token) { '1235' }

    it 'should ask the class to load the records' do
      RemotePost.expects(:all).with(token, ids: [comment1.post_id]).returns([remote_post])
      subject.auth_token(token).exec_queries.each do |comment|
        expect(comment.post).to eq remote_post
      end
    end

    it 'should still work (no nil pointer errors) if the relationship is orphaned' do
      RemotePost.expects(:all).with(token, ids: [comment1.post_id]).returns([])
      subject.auth_token(token).exec_queries.each do |comment|
        expect { comment.post }.to raise_error RemoteAssociations::Errors::MissingFetchBlockError
      end
    end
  end
end
