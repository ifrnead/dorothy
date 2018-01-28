module Dorothy::Model
  
  class Grader
    GRADE_COLUMN = { 1 => 3, 2 => 4, 5 => 6 }

    def initialize
      @browser = Dorothy::WebDriver::Browser.instance
      @settings = Dorothy::Model::Settings.instance
    end

    def fill(new_grade)
      student = new_grade.student
      grade = check_grade(new_grade.student)

      if not new_grade.exist?
        new_grade.value = 0
        puts "INFO: #{student} está sem nota no Moodle, lançando a nota zero"
      elsif new_grade.exist? and not grade
        puts "INFO: Lançando nota #{new_grade} para o aluno #{student}"
      elsif grade == 0
          puts "INFO: Sobrescrevendo a nota zero do aluno #{student} pela nota #{new_grade}"
      elsif new_grade == grade
        puts "INFO: A nota #{grade} já está lançada para o aluno #{student}"
        return
      else
        if @settings.force?
          puts "INFO: Sobrescrevendo a nota #{grade} do aluno #{student} pela nota #{new_grade}"
        else
          puts "WARNING: Já existe uma nota (#{grade}) lançada para o aluno #{student}, portanto a nota #{new_grade} não será lançada"
          return
        end
      end

      if student.has_id?
        grade_by_id(new_grade)
      else
        grade_by_fullname(new_grade)
      end
    end

    def reset(input)
      input.clear
    end

    def check_grade(student)
      input = nil
      begin
        input = @browser.find("//a[@href='/edu/aluno/#{student.id}/'][1]/../../../../td[#{GRADE_COLUMN[@settings.stage]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{@settings.activity}']/../following-sibling::td[1]/input")
      rescue Selenium::WebDriver::Error::NoSuchElementError
        begin
          input = @browser.find("//dd[contains(text(), '#{student.fullname}')]/../../../td[#{GRADE_COLUMN[@settings.stage]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{@settings.activity}']/../following-sibling::td[1]/input")
        rescue Selenium::WebDriver::Error::NoSuchElementError
          begin
            input = @browser.find("//dd[contains(text(), '#{student.fullname.upcase}')]/../../../td[#{GRADE_COLUMN[@settings.stage]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{@settings.activity}']/../following-sibling::td[1]/input")
          rescue Selenium::WebDriver::Error::NoSuchElementError
            return false
          end
        end
      end
      
      if input.value == ""
        return false
      end
      input.value.to_i
    end

    private

      def grade_by_id(grade)
        student = grade.student

        begin
          input = @browser.find( "//a[@href='/edu/aluno/#{student.id}/'][1]/../../../../td[#{GRADE_COLUMN[@settings.stage]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{@settings.activity}']/../following-sibling::td[1]/input")
          input.clear
          input.fill(grade.value)
        rescue Selenium::WebDriver::Error::NoSuchElementError
          puts "WARNING: Algo está errado! Talvez o aluno: #{student}; ou a atividade: #{@settings.activity} não exista(m)!"
        end
      end

      def grade_by_fullname(grade)
        student = grade.student
        input = nil

        begin
          input = @browser.find("//dd[contains(text(), '#{student.fullname}')]/../../../td[#{GRADE_COLUMN[@settings.stage]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{@settings.activity}']/../following-sibling::td[1]/input")
        rescue Selenium::WebDriver::Error::NoSuchElementError
          begin
            input = @browser.find("//dd[contains(text(), '#{student.fullname.upcase}')]/../../../td[#{GRADE_COLUMN[@settings.stage]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{@settings.activity}']/../following-sibling::td[1]/input")
          rescue Selenium::WebDriver::Error::NoSuchElementError
          end
        end

        if input
          input.clear
          input.fill(grade.value)
        else
          puts "WARNING: Algo está errado! Talvez o aluno: #{student}; ou a atividade: #{@settings.activity} não exista(m)!"
        end
      end

  end

end