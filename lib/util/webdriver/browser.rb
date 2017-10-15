require "selenium-webdriver"

module Dorothy
  module WebDriver
    class Browser
      attr_accessor :credentials, :username, :password

      def initialize
        client = Selenium::WebDriver::Remote::Http::Default.new
        client.read_timeout = 600 # seconds
        client.open_timeout = 600 # seconds
        @driver = Selenium::WebDriver.for :chrome, http_client: client
      end

      def get(url)
        @driver.get(url)
      end

      def fill(id:, value:)
        @driver.find_element(id: id).send_keys(value)
      end

      def find(method = :xpath, element)
        Dorothy::WebDriver::Element.new(@driver.find_element(method, element), @driver)
      end

      def finds(method = :xpath, element)
        @driver.find_elements(method, element).collect { |item|
          Dorothy::WebDriver::Element.new(item, @driver)
        }
      end

      def find_by(*args)
        Dorothy::WebDriver::Element.new(@driver.find_element(args), @driver)
      end
    end
  end
end
