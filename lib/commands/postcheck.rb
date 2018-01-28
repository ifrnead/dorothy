module Dorothy::Command

  class Postcheck
    # Usage: bin/grades postcheck <ID_DIARIO> <ARQUIVO_CSV> <ETAPA> <ATIVIDADE>

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
      grades_page.check(grades)
    end

    def valid_settings?
      errors = Array.new

      if @id.nil?
        errors << "ERROR: Forneça o número do diário"
      end

      unless File.exist?(@csv_file)
        errors << "ERROR: Arquivo #{@csv_file} não encontrado!"
      end

      if errors.empty?
        @valid = true
      end
      errors
    end

  end

end
