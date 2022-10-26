class InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  def copy_initializer_file
    template "initializer.rb.erb", "config/initializers/#{file_name}.rb"
  end
end
