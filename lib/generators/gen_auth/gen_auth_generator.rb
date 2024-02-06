class GenAuthGenerator < Rails::Generators::NamedBase
  include Rails::Generators::Migration
  source_root File.expand_path("templates", __dir__)

  def self.next_migration_number(dirname)
    ActiveRecord::Migration.new.next_migration_number(dirname.size + rand)
  end

  def create_controllers
    template "controllers/application_controller.rb.erb", "app/controllers/#{plural_name}/application_controller.rb"
    template "controllers/registrations_controller.rb.erb", "app/controllers/#{plural_name}/registrations_controller.rb"
    template "controllers/sessions_controller.rb.erb", "app/controllers/#{plural_name}/sessions_controller.rb"
    template "controllers/passwords_controller.rb.erb", "app/controllers/#{plural_name}/passwords_controller.rb"
  end

  def create_models_migrations
    migration_template "migrations/create_gen_auth_tables.rb.erb", "db/migrate/create_gen_auth_#{singular_name}_tables.rb"
  end

  # TODO:
  # Password Model
  # Views
  # Routes
  # Controllers
  # Mailers

  def create_models
    template "models/model.rb.erb", "app/models/#{singular_name}.rb"
    template "models/model_token.rb.erb", "app/models/#{singular_name}_token.rb"
  end
end
