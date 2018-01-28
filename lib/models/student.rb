module Dorothy::Model

  class Student
    attr_accessor :id, :email, :fullname

    def initialize(csv_row)
      @id = csv_row[:id_number]
      @fullname = "#{csv_row[:first_name]} #{csv_row[:surname]}"
      @email = csv_row[:email_address]
    end

    def hash
      if self.id.nil?
        self.fullname.hash
      else
        self.id.hash
      end
    end

    def ==(student)
      if student.id.nil? or self.id.nil?
        self.fullname.downcase == student.fullname.downcase
      else
        self.id == student.id
      end
    end

    def to_s
      "#{@fullname} (#{@id})"
    end

    def has_id?
      not self.id.nil?
    end

  end

end
