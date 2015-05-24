require 'spec_helper'
require 'active_record'
require 'bundler/psyched_yaml'
require 'shoulda/matchers'
connection_info = YAML.load_file("config/database.yml")["test"]

unless ActiveRecord::Base.connected?
  ActiveRecord::Base.establish_connection(connection_info)

  RSpec.configure do |config|
    config.around do |example|
      ActiveRecord::Base.transaction do
        example.run
        raise ActiveRecord::Rollback
      end
    end
  end
end