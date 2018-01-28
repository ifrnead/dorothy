module Dorothy::Model
  
  class GradesPage
    attr_accessor :id, :stage

    def initialize
      @id = Dorothy::Model::Settings.instance.id
      @stage = Dorothy::Model::Settings.instance.stage
      @activity = Dorothy::Model::Settings.instance.activity
      @browser = Dorothy::WebDriver::Browser.instance
      @browser.get "https://suap.ifrn.edu.br/edu/meu_diario/#{id}/#{stage}/?tab=notas"
    end

    def fill(grades)
      grader = Dorothy::Model::Grader.new
      grades.each do |grade|
        grader.fill(grade)
      end
    end

    def check(grades)
      grader = Dorothy::Model::Grader.new
      puts "INFO: Verifique as notas dos seguintes alunos:"
      grades.each do |grade|
        unless grader.check_grade(grade.student)
          puts "Aluno: #{grade.student}; Nota no Moodle: #{grade}"
        end
      end
    end

    def reset_grades
      grader = Dorothy::Model::Grader.new
      inputs = @browser.finds("//table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{@activity}']/../following-sibling::td[1]/input")
      
      puts "INFO: Apagando notas..."
      inputs.each do |input|
        grader.reset(input)
      end
      puts "INFO: Concluído!"
    end

    def submit
      @browser.find("//div[@class='action-bar submit-row']/input[@type='submit']").submit
      wait = Selenium::WebDriver::Wait.new(timeout: 60) # seconds
      wait.until { @browser.find("//p[@id='feedback_message']") }
    end

  end

end