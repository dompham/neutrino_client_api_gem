require './spec/spec_helper'
require './lib/neutrino/gateway/application_accounts'
require './lib/neutrino/gateway/requestor'
require 'fakeweb'

describe Neutrino::Gateway::ApplicationAccounts do

  let(:base_api) { 'base_api' }

  before(:each) do
    Neutrino::Api::Client.config = TestConfig.to_hash
  end

  describe 'self.create' do
    let(:new_account) { { 'access_id' => '1',
                          'secret_key' => 'ABCDEF0',
                          'authorization_level' => 'read_only',
                          'all_tenant_access' => true,
                          'tenant_tids' => [],
                          'enabled' => true,
                          'created_by' => 'test_user',
                          'updated_by' => 'test_user' } }

    it 'creates application accounts' do
      FakeWeb.register_uri(
        :post,
        'http://testhost:4242/api/v1/admin/application_accounts?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: new_account.to_json)

      expect(described_class.create(new_account)).to eq(new_account)
    end

    context 'when the server returns a 400 error' do

      before(:each) do
        FakeWeb.register_uri(
          :post,
          'http://testhost:4242/api/v1/admin/application_accounts?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: '{ "error" : "UnableToCreateApplicationAccountsError" }', status: ['400', 'Unable To Create Application Accounts'])
      end

      it 'raises an error' do
        expect { described_class.create(new_account) }.to raise_error(Neutrino::Gateway::Exceptions::UnableToCreateApplicationAccountsError)
      end
    end

  end

  describe 'self.index' do

    it 'gets application accounts' do
      FakeWeb.register_uri(
        :get,
        'http://testhost:4242/api/v1/admin/application_accounts?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: DataSamples.application_accounts.to_s)

      expect(described_class.index).to eq(DataSamples.application_accounts.to_hash)
    end

    context 'when the server returns a 400 error' do

      before(:each) do
        FakeWeb.register_uri(
          :get,
          'http://testhost:4242/api/v1/admin/application_accounts?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'UnableToRetrieveApplicationAccountsError', status: ['400', 'Unable To Retrieve Application Accounts'])
      end

      it 'raises an error' do
        expect { described_class.index }.to raise_error(Neutrino::Gateway::Exceptions::UnableToRetrieveApplicationAccountsError)
      end
    end

  end

  describe 'self.find_by_id' do
    let(:account) { { 'id' => 1,
                      'access_id' => '1',
                      'authorization_level' => 'read_only',
                      'all_tenant_access' => true,
                      'tenant_tids' => [],
                      'enabled' => true,
                      'created_by' => 'test_user',
                      'updated_by' => 'test_user' } }

    it 'gets an application account' do
      FakeWeb.register_uri(
        :get,
        'http://testhost:4242/api/v1/admin/application_accounts/1?debug=false&user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: account.to_json)

      expect(described_class.find_by_id(1)).to eq(account)
    end

    it 'gets an application account with a secret key' do
      FakeWeb.register_uri(
        :get,
        'http://testhost:4242/api/v1/admin/application_accounts/1?debug=true&user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: account.to_json)

      expect(described_class.find_by_id(1, true)).to eq(account)
    end

    context 'when the server returns a 400 error' do

      before(:each) do
        FakeWeb.register_uri(
          :get,
          'http://testhost:4242/api/v1/admin/application_accounts/1?debug=false&user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: 'UnableToRetrieveApplicationAccountsError', status: ['400', 'Unable To Retrieve Application Accounts'])
      end

      it 'raises an error' do
        expect { described_class.find_by_id(1) }.to raise_error(Neutrino::Gateway::Exceptions::UnableToRetrieveApplicationAccountsError)
      end
    end

  end

  describe 'self.update_by_id' do
    let(:update_account) { { 'id' => 1,
                             'access_id' => '1',
                             'secret_key' => 'ABCDEF0',
                             'authorization_level' => 'read_only',
                             'all_tenant_access' => true,
                             'tenant_tids' => ['neutrino'],
                             'enabled' => true,
                             'created_by' => 'test_user',
                             'updated_by' => 'test_user' } }

    it 'gets an application account' do
      FakeWeb.register_uri(
        :post,
        'http://testhost:4242/api/v1/admin/application_accounts/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
        body: update_account.to_json)

      expect(described_class.update_by_id(1, update_account)).to eq(update_account)
    end

    context 'when the server returns a 400 error' do

      before(:each) do
        FakeWeb.register_uri(
          :post,
          'http://testhost:4242/api/v1/admin/application_accounts/1?user%5Bextension%5D=spameggs&user%5Broot%5D=foobar',
          body: '{ "error" : "UnableToUpdateApplicationAccountsError" }', status: ['400', 'Unable To Update Application Accounts'])
      end

      it 'raises an error' do
        expect { described_class.update_by_id(1, update_account) }.to raise_error(Neutrino::Gateway::Exceptions::UnableToUpdateApplicationAccountsError)
      end
    end

  end

end