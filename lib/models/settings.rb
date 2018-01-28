require 'optparse'
require 'singleton'
require 'yaml'

module Dorothy::Model

  class Settings
    include Singleton
    attr_accessor :csv, :id, :activity, :force, :stage, :username, :password

    def initialize
      @csv = "data/grades.csv"
      @force = false
      @stage = 1
    end

    def load_credentials
      credentials = YAML.load_file("credentials.yml")
      @username = credentials["username"]
      @password = credentials["password"]
    end

    def force?
      @force
    end

    def load_options
      opt_parser = OptionParser.new do |opt|
        opt.banner = "USAGE: bin/grades COMMAND [OPTIONS]"
        opt.separator ""
        opt.separator "COMMANDS"
        opt.separator "     migrate                         migra notas do Moodle para o SUAP"
        opt.separator "     postcheck                       verifica se todas as notas do Moodle foram lançadas"
        opt.separator "     reset                           apaga todas as notas de uma atividade específica"
        opt.separator ""
        opt.separator "OPTIONS"
      
        opt.on("-c", "--csv CSV_FILE", "Caminho do arquivo CSV exportado do Moodle") do |csv|
          @csv = csv
        end
      
        opt.on("-id", "--id ID", "Número do diário no SUAP") do |id|
          @id = id
        end
      
        opt.on("-a", "--activity DESCRIPTION", "Descrição da atividade no SUAP") do |activity|
          @activity = activity
        end
      
        opt.on("-f", "--force", "Sobrescreve todas as notas lançadas no diário pelas notas do arquivo CSV") do
          @force = true
        end
      
        opt.on("-s", "--stage STAGE", "Número da etapa da atividade no SUAP") do |stage|
          stage = 5 if stage == 'final'
          @stage = stage
        end
      end
      
      opt_parser.parse!
    end
  end

end