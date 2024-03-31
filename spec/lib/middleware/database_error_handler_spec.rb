require 'rails_helper'
require 'middleware/database_error_handler'

RSpec.describe DatabaseErrorHandler do
  describe '#call' do
    let(:app) { instance_double(Rack::Runtime) }
    let(:env) { { 'rack.input' => StringIO.new } }

    before do
      allow(ActiveRecord::Base.connection).to receive(:database_exists?).and_return(true)
      allow(ActiveRecord::Base.connection.migration_context).to receive(:needs_migration?).and_return(true)
    end

    context 'when the database exists and does not need migration' do
      it 'calls the next middleware' do
        expect(app).to receive(:call).with(env)
        described_class.new(app).call(env)
      end
    end

    context 'when the database does not exist' do
      before do
        allow(ActiveRecord::Base.connection).to receive(:database_exists?).and_return(false)
      end

      it 'returns a 503 status with an error message' do
        status, headers, body = described_class.new(app).call(env)
        expect(status).to eq(503)
        expect(headers).to eq('Content-Type' => 'application/json')
        expect(body).to eq([{ error: 'Database does not exist', status: 503 }.to_json])
      end
    end
  end
end
