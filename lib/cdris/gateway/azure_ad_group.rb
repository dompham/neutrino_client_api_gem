require 'cdris/gateway/requestor'
require 'cdris/gateway/exceptions'

module Cdris
  module Gateway
    class AzureAdGroup < Cdris::Gateway::Requestor
      private_class_method :new
      class << self

        # Show all azure groups
        def show_azure_ad_groups(options = {})
          path = base_uri
          request(path, options).to_json
        end

        # Creates a new azure group
        def create(azure_ad_group_body, options = {})
          path = base_uri
          request(path, options.merge(method: :post), azure_ad_group_body).if_400_raise(Cdris::Gateway::Exceptions::AzureAdGroupInvalidError)
            .to_hash
        end

        # Gets an azure group
        def get(params, options = {})
          path = "#{base_uri}/#{params[:id]}"
          request(path, options).if_404_raise(Cdris::Gateway::Exceptions::AzureAdGroupNotFoundError)
            .if_400_raise(Cdris::Gateway::Exceptions::AzureAdGroupInvalidError)
            .to_hash
        end

        # Update an azure group
        def update_by_id(params, options = {})
          path = "#{base_uri}/#{params[:id]}"
          request(path, options.merge(method: :post), params).if_404_raise(Cdris::Gateway::Exceptions::AzureAdGroupNotFoundError)
            .if_400_raise(Cdris::Gateway::Exceptions::AzureAdGroupInvalidError)
            .to_hash
        end

        # Delete an azure group
        def delete_by_id(params, options = {})
          path = "#{base_uri}/#{params[:id]}"
          request(path, options.merge(method: :delete)).if_404_raise(Cdris::Gateway::Exceptions::AzureAdGroupNotFoundError)
        end

        # Gets the base URI for an azure group
        #
        # @return [String] the base URI for an azure group
        def base_uri
          "#{api}/azure_ad_group"
        end
      end
    end
  end
end
