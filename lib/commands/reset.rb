module Dorothy::Command

  class Reset
    # Usage: bin/grades migrate <ID_DIARIO> <ETAPA> <ATIVIDADE>

    def initialize
      @id = Dorothy::Model::Settings.instance.id
      @stage = Dorothy::Model::Settings.instance.stage
      @activity = Dorothy::Model::Settings.instance.activity
    end

    def execute
      Dorothy::SUAP::Web.authenticate
      grades_page = Dorothy::Model::GradesPage.new
      grades_page.reset_grades
      grades_page.submit
    end

    def valid_settings?
      errors = Array.new

      if @id.nil?
        errors << "ERROR: Forneça o número do diário!"
      end

      if @stage.nil?
        errors << "ERROR: Forneça o número da etapa!"
      end

      if @activity.nil?
        errors << "ERROR: Forneça a descrição da atividade!"
      end

      if errors.empty?
        @valid = true
      end
      errors
    end

  end

end