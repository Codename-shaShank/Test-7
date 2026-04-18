ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Minitest 6.x changed Runnable.run from a suite-level (reporter, options)
# method to a per-test (klass, method_name, reporter) method. Rails 7.0.x
# LineFiltering was written for the minitest 5.x signature and causes an
# ArgumentError when minitest calls run with 3 args. This shim restores
# compatibility by accepting any arguments and delegating to super.
# prepend is used here (rather than reopening the module) to ensure this
# definition takes precedence over Rails::LineFiltering's existing run method
# in the ancestor chain of Minitest::Runnable.
MINITEST_6_OR_LATER = Gem::Version.new(Minitest::VERSION) >= Gem::Version.new("6.0.0")
if defined?(Rails::LineFiltering) && MINITEST_6_OR_LATER
  Rails::LineFiltering.prepend(Module.new { def run(*args) = super })
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
