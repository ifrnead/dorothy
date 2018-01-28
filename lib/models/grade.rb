module Dorothy::Model

  class Grade
    attr_accessor :value, :student

    def initialize(csv_row)
      @student = Dorothy::Model::Student.new(csv_row)
      if csv_row[4] == '-'
        @value = nil
      else
        @value = csv_row[4].to_i
      end
    end

    def self.from_csv(csv_file)
      grades = []
      data = Dorothy::Util::CSVFile.new(csv_file)
      data.each do |csv_row|
        grades << Grade.new(csv_row)
      end
      grades
    end

    def ==(grade)
      grade.to_i == @value
    end

    def to_s
      @value.to_s
    end

    def to_i
      @value
    end

    def zero?
      @value == 0
    end

    def exist?
      not @value.nil?
    end
  
  end

end