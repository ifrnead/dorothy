require 'csv'

module Dorothy
  module Util
    class CSVFile

      def initialize(path)
        @path = path
        @data = CSV.read(path, { encoding: "UTF-8", headers: true, header_converters: :symbol, converters: :all})
      end

      def each
        @data.each do |item|
          yield item
        end
      end

    end
  end
end
