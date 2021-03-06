module Dorothy
  module WebDriver
    class Element
      include Enumerable

      def initialize(element, driver)
        @element = element
        @driver = driver
      end

      def click
        @element.click
      end

      def submit
        @element.submit
      end

      def text
        @element.text
      end

      def attribute(attr_name)
        @element.attribute(attr_name)
      end

      def value
        @element.attribute('value')
      end

      def clear
        @element.clear
        @element.send_keys(:tab)
      end

      def fill(value)
        @element.send_keys(value)
        @element.send_keys(:tab)
      end

      def find(method = :xpath, element)
        Dorothy::WebDriver::Element.new(@element.find_element(method, element), @driver)
      end

      def finds(method = :xpath, element)
        @element.find_elements(method, element).collect { |item|
          Dorothy::WebDriver::Element.new(item, @driver)
        }
      end

      def find_by(*args)
        Dorothy::WebDriver::Element.new(@element.find_element(args), @driver)
      end
    end
  end
end
