$:.unshift('lib') unless $:.first == 'lib'

require 'mysql_parser'

RSpec.configure { |config|
  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }
}
