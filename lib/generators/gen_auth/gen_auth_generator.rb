class GenAuthGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration
  source_root File.expand_path("templates", __dir__)

  def self.next_migration_number(dirname)
    ActiveRecord::Migration.new.next_migration_number(dirname.size + rand)
  end

  def create_controllers
    controller_names = %w(
      application_controller
      confirmations_controller
      passwords_controller
      registrations_controller
      reset_passwords_controller
      sessions_controller
      settings_controller
    )

    controller_names.each do |controller_name|
      template "controllers/#{controller_name}.rb.erb", "app/controllers/#{plural_name}/#{controller_name}.rb"
    end
  end

  def create_controller_tests
    test_files = %w(
      confirmations_controller_test
      passwords_controller_test
      registrations_controller_test
      reset_passwords_controller_test
      sessions_controller_test
      settings_controller_test
    )

    test_files.each do |test_file|
      template "tests/controllers/#{test_file}.rb.erb", "test/controllers/#{plural_name}/#{test_file}.rb"
    end
  end

  def create_models_migrations
    migration_template "migrations/create_gen_auth_tables.rb.erb", "db/migrate/create_gen_auth_#{singular_name}_tables.rb"
  end

  def create_views
  end

  # TODO:
  # Views
  # Routes
  # Mailers

  def create_models
    template "models/model.rb.erb", "app/models/#{singular_name}.rb"
    template "models/model_token.rb.erb", "app/models/#{singular_name}_token.rb"
  end

  def create_model_tests
    template "tests/models/model_test.rb.erb", "test/models/#{singular_name}_test.rb"
    template "tests/models/model_token_test.rb.erb", "test/models/#{singular_name}_token_test.rb"
  end
end
