require 'remote_associations'
require 'mocha/api'

Dir[File.expand_path('support/**/*.rb', File.dirname(__FILE__))].each do |f|
  require Pathname.new(f).relative_path_from(Pathname.new(File.dirname(__FILE__)))
end

RSpec.configure do |config|
  config.mock_with :mocha

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = 'random'
end
