module Dorothy::Command

  class Migrate
    # Usage: bin/grades migrate <ID_DIARIO> <ARQUIVO_CSV> <ETAPA> <ATIVIDADE>

    def initialize(params)
      @id = params[0].to_i
      @csv_file = params[1]
      @phase = params[2].to_i
      @activity = params[3]
    end

    def execute
      unless @valid
        puts "ERROR: You need to validate params before execute"
        return false
      end

      web = Dorothy::SUAP::Web.new('credentials.yml')
      ava = Dorothy::AVA::CSVFile.new(@csv_file)
      web.open_grades_page(@id, @phase)
      ava.students.each do |student|
        web.grade(student, @phase, @activity)
      end
      web.submit_grades
    end

    def valid_params?
      errors = Array.new

      if @id.nil?
        errors << "ERROR: Please provide the ID!"
      end

      if @phase.nil?
        errors << "ERROR: Please provide the Phase number!"
      end

      unless File.exist?(@csv_file)
        errors << "ERROR: File #{@csv_file} not found!"
      end

      if errors.empty?
        @valid = true
      end
      errors
    end

  end

end
