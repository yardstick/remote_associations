require 'spec_helper'

describe RemoteAssociations::RemoteAssociation do
  describe :klass do
    it 'should raise an error when no class option is specified' do
      assoc = RemoteAssociations::RemoteAssociation.new(:orange)
      expect { assoc.klass }.to raise_error ArgumentError
    end
  end
end
