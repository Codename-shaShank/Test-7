ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Minitest 6.x changed Runnable.run from a suite-level (reporter, options)
# method to a per-test (klass, method_name, reporter) method. Rails 7.0.x
# LineFiltering prepends run(reporter, options={}) onto Minitest::Runnable,
# which conflicts with minitest 6's 3-arg call signature. Redefine run
# directly in Rails::LineFiltering to accept variadic args; super then
# delegates to Minitest::Runnable#run (the correct minitest 6 implementation).
if defined?(Rails::LineFiltering) && Gem::Version.new(Minitest::VERSION) >= Gem::Version.new("6.0.0")
  module Rails::LineFiltering
    def run(*args)
      super
    end
  end
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
