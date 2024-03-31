RSpec.describe ApplicationController do
  let(:controller) { described_class.new }

  describe '#authenticate' do
    before do
      allow(controller).to receive(:authenticate_token).and_return(authenticate)
    end

    context 'when token is valid' do
      let(:authenticate) { true }

      it do
        expect(controller).not_to receive(:render_unauthorized)
        controller.send(:authenticate)
      end
    end

    context 'when token is invalid' do
      let(:authenticate) { false }

      it do
        expect(controller).to receive(:render_unauthorized)
        controller.send(:authenticate)
      end
    end
  end

  describe '#record_not_found' do
    it do
      expect(controller).to receive(:render).with(json: { error: 'Record not found' }, status: :not_found)
      controller.send(:record_not_found)
    end
  end

  describe '#render_unprocessable_entity_response' do
    let(:errors_double) { instance_double(ActiveModel::Errors, full_messages: ['error']) }
    let(:record_double) { instance_double(ActiveRecord::Base, errors: errors_double) }
    # rubocop:disable RSpec/VerifiedDoubleReference
    let(:invalid) { instance_double('Parameters', record: record_double) }
    # rubocop:enable RSpec/VerifiedDoubleReference

    it do
      expect(controller).to receive(:render).with(json: { errors: ['error'] }, status: :unprocessable_entity)
      controller.send(:render_unprocessable_entity_response, invalid)
    end
  end
end
