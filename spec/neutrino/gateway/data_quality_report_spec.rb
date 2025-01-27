require './spec/spec_helper'
require './lib/neutrino/gateway/data_quality_report'
require './lib/neutrino/gateway/requestor'
require './lib/neutrino/gateway/exceptions'
require 'fakeweb'

describe Neutrino::Gateway::DataQualityReport do

  before(:each) do
    Neutrino::Api::Client.config = TestConfig.to_hash
  end

  describe 'self.summary' do

    let(:path) { '/api/v1/reports/data-quality/summary' }
    let(:response_message) { { 'content' => 'some data', 'message'=>'The system is updating the report' }  }

    before(:each) do
      FakeWeb.register_uri(
        :get,
        'http://testhost:4242/api/v1/reports/data-quality/summary?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: response_message.to_json , status: ['200', 'OK'])
    end

    it 'returns the expected result' do
      expect(described_class.summary).to eq(response_message)
    end

    context 'when the server returns a 400 error' do

      before(:each) do
        FakeWeb.register_uri(
          :get,
          'http://testhost:4242/api/v1/reports/data-quality/summary?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'Bad Request', status: ['400', 'Bad Request'])
      end

      it 'raises a bad request error' do
        expect { described_class.summary }.to raise_error(Neutrino::Gateway::Exceptions::BadRequestError)
      end

    end

  end
end
