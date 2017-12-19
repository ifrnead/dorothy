require "selenium-webdriver"
require 'rest-client'
require 'yaml'
require 'json'

module Dorothy
  module SUAP
    class API
      attr_accessor :credentials, :username, :password, :token

      def initialize(credentials)
        @credentials = YAML.load_file(credentials)
        @username = credentials["username"]
        @password = credentials["password"]
        response = RestClient.post('https://suap.ifrn.edu.br/api/v2/autenticacao/token/', { "username": @username, "password": @password }.to_json, { content_type: :json, accept: :json })
        @token = JSON.parse(response.body)["token"]
      end

      def get_diario(id:)
        response = RestClient.get("https://suap.ifrn.edu.br/api/v2/minhas-informacoes/meu-diario/#{id}", headers(@token))
        return JSON.parse(response.body)
      end

      private

      def headers(token)
        {
          'Content-Type': 'application/json',
          'Authorization': "JWT #{token}"
        }
      end
    end
  end
end
