Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  # config.action_mailer.deliver_method = :smtp
  ENV['LINKEDIN_CLIENT_ID'] = "8196sktbspksp9"
  ENV['LINKEDIN_CLIENT_SECRET'] = "WBvSYefhd2Hn7vVb"
  ENV['TWITTER_API_KEY'] = "K3NhmoPIYPx5Xt83JiQXq78cU"
  ENV['TWITTER_API_SECRET'] = "C9rCRLBtArIU9fK9oXcLU7LWzHFcpNNbwLFrstTiYNAonIRK15"
  ENV["AWS_ACCESS_KEY_ID"] = "AKIAIVBSYLFWWIBEU37Q"
  ENV["AWS_SECRET_ACCESS_KEY"] = "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"
end
