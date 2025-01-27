require './spec/spec_helper'
require './lib/neutrino/gateway/requestor'
require './lib/neutrino/gateway/exceptions'
require './lib/neutrino/gateway/root'
require 'fakeweb'

describe Neutrino::Gateway::Root do

  before(:each) do
    Neutrino::Api::Client.config = TestConfig.to_hash
  end

  describe 'self.create' do

    let(:path) { '/api/v1/root' }
    let(:body) { { 'root_type' => 'invalid', 'root' => 'test', 'long_desc' => 'long', 'short_desc' => 'short '} }
    let(:response_message) { { 'id' => '1', 'root_type' => 'invalid', 'root' => 'test', 'long_desc' => 'long', 'short_desc' => 'short ' } }

    before(:each) do
      FakeWeb.register_uri(
        :post,
        'http://testhost:4242/api/v1/root?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: response_message.to_json , status: ['200', 'OK'])
    end

    it 'performs a post request' do
      expect(Neutrino::Gateway::Requestor).to receive(:request).with(path, { method: :post }, body).and_call_original
      expect(described_class.create(body)).to eq(response_message)
    end

    context 'when the invalid root' do

      before(:each) do
        FakeWeb.register_uri(
          :post,
          'http://testhost:4242/api/v1/root?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'Root Invalid', status: ['400', 'Root Invalid'])
      end

      it 'raises a root invalid error' do
        expect { described_class.create(body) }.to raise_error(Neutrino::Gateway::Exceptions::RootInvalidError)
      end
    end

    context 'when associated provider does not exist' do

      before(:each) do
        FakeWeb.register_uri(
          :post,
          'http://testhost:4242/api/v1/root?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: '{ "error": "Create or update a root with a non-existent provider" }', status: ['400'])
      end

      it 'raises a PostRootWithNonExistProviderError' do
        expect { described_class.create(body) }.to raise_error(Neutrino::Gateway::Exceptions::PostRootWithNonExistProviderError)
      end
    end


  end

  describe 'self.show_roots' do

    let(:response_message) { [{ 'id' => '1', 'root_type' => 'invalid', 'root' => 'test', 'long_desc' => 'long', 'short_desc' => 'short' }] }

    before(:each) do
      FakeWeb.register_uri(
        :get,
        'http://testhost:4242/api/v1/root?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: response_message.to_json , status: ['200', 'OK'])
    end

    it 'returns the expected result' do
      expect(described_class.show_roots({})).to eq(response_message.to_json)
    end

  end

  describe 'self.get' do

    let(:response_message) { { 'id' => '1', 'root_type' => 'invalid', 'root' => 'test', 'long_desc' => 'long', 'short_desc' => 'short' } }

    before(:each) do
      FakeWeb.register_uri(
        :get,
        'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: response_message.to_json , status: ['200', 'OK'])
    end

    it 'returns the expected result' do
      expect(described_class.get(id: 1)).to eq(response_message)
    end

    context 'when the server returns a 400 error' do

      before(:each) do
        FakeWeb.register_uri(
          :get,
          'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'Root Invalid', status: ['400', 'Root Invalid'])
      end

      it 'raises a root invalid error' do
        expect { described_class.get(id: 1) }.to raise_error(Neutrino::Gateway::Exceptions::RootInvalidError)
      end
    end

    context 'when the server returns a 404 error' do

      before(:each) do
        FakeWeb.register_uri(
          :get,
          'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'Root Not Found', status: ['404', 'Root Not Found'])
      end

      it 'raises a root not found error' do
        expect { described_class.get(id: 1) }.to raise_error(Neutrino::Gateway::Exceptions::RootNotFoundError)
      end
    end
  end

  describe 'self.update_by_id' do

    let(:response_message) { { 'id' => '1', 'root_type' => 'invalid', 'root' => 'test', 'long_desc' => 'long', 'short_desc' => 'short '} }

    before(:each) do
      FakeWeb.register_uri(
        :post,
        'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: response_message.to_json , status: ['200', 'OK'])
    end

    it 'returns the expected result' do
      expect(described_class.update_by_id(id: 1)).to eq(response_message)
    end

    context 'when the server returns a 400 error' do

      before(:each) do
        FakeWeb.register_uri(
          :post,
          'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'Root Invalid', status: ['400', 'Root Invalid'])
      end

      it 'raises a root invalid error' do
        expect { described_class.update_by_id(id: 1) }.to raise_error(Neutrino::Gateway::Exceptions::RootInvalidError)
      end
    end

    context 'when associated provider does not exist' do

      before(:each) do
        FakeWeb.register_uri(
          :post,
          'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: '{ "error": "Create or update a root with a non-existent provider" }', status: ['400'])
      end

      it 'raises a root invalid error' do
        expect { described_class.update_by_id(id: 1) }.to raise_error(Neutrino::Gateway::Exceptions::PostRootWithNonExistProviderError)
      end
    end

    context 'when the server returns a 404 error' do

      before(:each) do
        FakeWeb.register_uri(
          :post,
          'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'Root Not Found', status: ['404', 'Root Not Found'])
      end

      it 'raises a root not found error' do
        expect { described_class.update_by_id(id: 1) }.to raise_error(Neutrino::Gateway::Exceptions::RootNotFoundError)
      end
    end
  end

  describe 'self.delete_by_id' do

    before(:each) do
      FakeWeb.register_uri(
        :delete,
        'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: {}.to_json, status: ['200', 'OK'])
    end

    it 'returns the expected result' do
      expect(described_class.delete_by_id(id: 1).to_hash).to eq({})
    end

    context 'when the server returns a 404 error' do

      before(:each) do
        FakeWeb.register_uri(
          :delete,
          'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'Root Not Found', status: ['404', 'Root Not Found'])
      end

      it 'raises a root not found error' do
        expect { described_class.delete_by_id(id: 1) }.to raise_error(Neutrino::Gateway::Exceptions::RootNotFoundError)
      end
    end

    context 'when performs a request returning 409 - requested deletion of a root assigned to a provider' do

      before(:each) do
        FakeWeb.register_uri(
          :delete,
          'http://testhost:4242/api/v1/root/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: '{ "error": "Deletion of a root assigned to a provider is not allowed" }', status: ['409', 'Error'])
      end

      it 'raises DeleteRootWithProviderError' do
        expect { described_class.delete_by_id(id: 1) }.to raise_error(Neutrino::Gateway::Exceptions::DeleteRootWithProviderError)
      end
    end
  end
end
