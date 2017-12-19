module Dorothy::Command

  class Reset
    # Usage: bin/grades migrate <ID_DIARIO> <ETAPA> <ATIVIDADE>

    def initialize(params)
      @id = params[0].to_i
      @phase = params[1].to_i
      @activity = params[2]
    end

    def execute
      web = Dorothy::SUAP::Web.new('credentials.yml')
      web.open_grades_page(@id, @phase)
      web.reset_grades(@activity)
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

      if errors.empty?
        @valid = true
      end
      errors
    end

  end

end