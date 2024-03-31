class DatabaseErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    return [503, { 'Content-Type' => 'application/json' }, [{ error: 'Database does not exist', status: 503 }.to_json]] unless ActiveRecord::Base.connection.database_exists?

    ActiveRecord::Base.connection.migration_context.needs_migration? ? ActiveRecord::Migration.check_all_pending! : @app.call(env)
  rescue ActiveRecord::PendingMigrationError
    [503, { 'Content-Type' => 'application/json' }, [{ error: 'Database is currently unavailable', status: 503 }.to_json]]
  end
end
