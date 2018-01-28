module Dorothy::Command

  class Migrate
    # Usage: bin/grades migrate <ID_DIARIO> <ARQUIVO_CSV> <ETAPA> <ATIVIDADE>

    def initialize
      @id = Dorothy::Model::Settings.instance.id
      @csv_file = Dorothy::Model::Settings.instance.csv
      @stage = Dorothy::Model::Settings.instance.stage
      @activity = Dorothy::Model::Settings.instance.activity
    end

    def execute
      grades = Dorothy::Model::Grade.from_csv(@csv_file)
      Dorothy::SUAP::Web.authenticate
      grades_page = Dorothy::Model::GradesPage.new
      grades_page.fill(grades)
      grades_page.submit
    end

    def valid_settings?
      errors = Array.new

      if @id.nil?
        errors << "ERROR: Forneça o número do diário!"
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
