require "active_record/connection_adapters/postgresql_adapter"

# Make timestamp with time zone the default datetime type
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :timestamptz
