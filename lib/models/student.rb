module Dorothy::Model

  class Student
    attr_accessor :id, :email, :fullname, :grade

    def self.create_from_csv(params)
      student = Student.new
      student.id = params[2]
      student.email = params[3]
      student.fullname = "#{params[0]} #{params[1]}"
      student.grade = params[4]
      student
    end

    def self.create_from_json(params)
      student = Student.new
      student.id = params["matricula"]
      student.email = params["email"]
      student.fullname = params["nome"]
      student
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

    def has_grade?
      (not @grade.nil?) and @grade != '-'
    end

    def has_id?
      not self.id.nil?
    end

  end

end
