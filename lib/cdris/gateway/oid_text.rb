require 'cdris/gateway/requestor'
require 'cdris/gateway/exceptions'
require 'open-uri'

module Cdris
  module Gateway
    class OidText < Cdris::Gateway::Requestor
      private_class_method :new
      class << self

        # Gets oid text
        #
        # @param [Hash] params specify what oid text to get, either `group` , or `:group` and `:oid`
        # @param [Hash] options specify query values
        # @return [Hash] the oid text
        def get(params = {}, options = {})
          path = "#{api}/oid_text"
          path << '/' + URI::encode(params['group']) if params['group']
          path << '/' + params['oid'] if params['oid'] && params['group']
          request(path, options).to_hash
        end

      end
    end
  end
end
