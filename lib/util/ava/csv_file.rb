require 'csv'

module Dorothy
  module AVA
    class CSVFile
      attr_reader :students

      def initialize(path)
        @path = path
        @data = CSV.read(path, { headers: true })
        load_students
      end

      private

      def load_students
        @students = Array.new
        @data.each do |row|
          @students << Dorothy::Model::Student.create_from_csv(row)
        end
      end

    end
  end
end
