module Dorothy::Command

  class Reset

    def initialize(params)
      @id = params[0].to_i
      @phase = params[1].to_i
      @activity = params[2]
    end

    def execute
      web = Dorothy::SUAP::Web.new('credentials.yml')
      web.open_grades_page(@id, @phase)
      web.students(@id).each do |student|
        student.grade = 0
        web.grade(student, @phase, @activity)
      end
      web.submit_grades
    end

  end

end