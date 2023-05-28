require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
# require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ServiceOrderRabbitmq
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    config.after_initialize do
      require File.expand_path('/var/www/service-order-rabbitmq/config/environment', __dir__)

      connection = Bunny.new('amqps://okezsgfv:2-UBqLVbLRRVlUrDTAANhLCf-wj4BGgB@toad.rmq.cloudamqp.com/okezsgfv')
      connection.start
      channel = connection.create_channel

      queue = channel.queue('users.in', durable: true, auto_delete: false)

      puts ' [*] Waiting for messages. To exit press CTRL+C'

      fanout_name = 'users.out'
      queue.bind(channel.exchange(fanout_name, type: :fanout))

      puts "[consumer] #{queue.name} bound to #{fanout_name} exchange"

      queue.subscribe do |d_info, properties, payload|
        BunnyConsumer.call!(properties, payload)
        puts "[consumer] #{queue.name} received #{properties[:type]}, from #{properties[:app_id]} with payload: #{payload}\n"
      end
    end
  end
end
