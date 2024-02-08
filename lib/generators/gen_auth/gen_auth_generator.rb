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

  def create_views
    Dir.glob("#{source_paths.first}/views/**/*.erb") do |file_path|
      folder_name, file_name = file_path.sub("#{source_paths.first}/views/", "").split("/")
      relative_path = file_path.sub("#{source_paths.first}/views/", "")

      template "views/#{relative_path}", "app/views/#{plural_name}/#{folder_name}/#{file_name}"
    end
  end

  def create_mailers
    template "mailers/model_mailer.rb.erb", "app/mailers/#{singular_name}_mailer.rb"

    Dir.glob("#{source_paths.first}/mailers/views/*.erb") do |file_path|
      file_name = File.basename(file_path)

      template "mailers/views/#{file_name}", "app/views/#{singular_name}_mailer/#{file_name}"
    end
  end

  def create_fixtures
    template "tests/fixtures/model.yml.erb", "test/fixtures/#{plural_name}.yml"
    template "tests/fixtures/model_tokens.yml.erb", "test/fixtures/#{singular_name}_tokens.yml"
  end

  def create_concerns
    template "concerns/model_authentication.rb.erb", "app/controllers/concerns/#{singular_name}_authentication.rb"
  end
end
