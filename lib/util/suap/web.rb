
require 'rest-client'
require 'yaml'
require 'json'

module Dorothy
  module SUAP
    class Web

      GRADE_COLUMN = { 1 => 3, 2 => 4, 5 => 6 }

      def initialize(credentials)
        @credentials = YAML.load_file(credentials)
        @username = @credentials["username"]
        @password = @credentials["password"]
        @browser = Dorothy::WebDriver::Browser.new
      end

      def authenticate
        @browser.get "https://suap.ifrn.edu.br"
        @browser.fill(id: 'id_username', value: @username)
        @browser.fill(id: 'id_password', value: @password)

        if button = @browser.find("//*[@id=\"content\"]/div[1]/form/div[3]/input")
          button.click
        end
      end

      def get_students_from_diario(id:)
        self.authenticate
        @browser.get "https://suap.ifrn.edu.br/edu/meu_diario/#{id}/1/?tab=notas"
        students = []

        tables = @browser.finds("//table[@id=\"table_notas\"]")
        tables.each do |table|
          rows = table.finds("tbody/tr")
          rows.each do |row|
            element = row.find("td[2]/dl/dd")
            student = Dorothy::Model::Student.new
            student.fullname = element.value.split(" (").first
            student.id = element.value.match(/[0-9]+/).to_s
            students << student
          end
        end
        students
      end

      def open_grades_page(id, phase)
        self.authenticate
        @browser.get "https://suap.ifrn.edu.br/edu/meu_diario/#{id}/#{phase}/?tab=notas"
      end

      def grade(student, phase, activity)
        grade = check_grade(student, phase, activity)
        unless grade
          student.grade = 0 if not student.has_grade?
          puts "Lançando nota: #{student.to_s} => #{student.grade}"
          if student.has_id?
            grade_by_id(student, phase, activity)
          else
            grade_by_fullname(student, phase, activity)
          end
        else
          puts "O aluno #{student.to_s} já tem uma nota lançada!"
        end
      end

      def check_grade(student, phase, activity)
        input = nil
        begin
          input = @browser.find( "//a[@href='/edu/aluno/#{student.id}/'][1]/../../../../td[#{GRADE_COLUMN[phase]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{activity}']/../following-sibling::td[1]/input")
        rescue Selenium::WebDriver::Error::NoSuchElementError
          begin
            input = @browser.find("//dd[contains(text(), '#{student.fullname}')]/../../../td[#{GRADE_COLUMN[phase]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{activity}']/../following-sibling::td[1]/input")
          rescue Selenium::WebDriver::Error::NoSuchElementError
            begin
              input = @browser.find("//dd[contains(text(), '#{student.fullname.upcase}')]/../../../td[#{GRADE_COLUMN[phase]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{activity}']/../following-sibling::td[1]/input")
            rescue Selenium::WebDriver::Error::NoSuchElementError
              return false
            end
          end
        end
        
        if input.value == ""
          return false
        end
        input.value
      end

      private

      def grade_by_id(student, phase, activity)
        begin
          input = @browser.find( "//a[@href='/edu/aluno/#{student.id}/'][1]/../../../../td[#{GRADE_COLUMN[phase]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{activity}']/../following-sibling::td[1]/input")
          input.clear
          input.fill(student.grade)
        rescue Selenium::WebDriver::Error::NoSuchElementError
          puts "WARNING: Algo está errado! Talvez o aluno: #{student}; ou a atividade: #{activity} não exista(m)!"
        end
      end

      def grade_by_fullname(student, phase, activity)
        input = nil
        begin
          input = @browser.find("//dd[contains(text(), '#{student.fullname}')]/../../../td[#{GRADE_COLUMN[phase]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{activity}']/../following-sibling::td[1]/input")
        rescue Selenium::WebDriver::Error::NoSuchElementError
          begin
            input = @browser.find("//dd[contains(text(), '#{student.fullname.upcase}')]/../../../td[#{GRADE_COLUMN[phase]}]/table[@class='info'][1]/tbody/tr/td/label[@data-hint='#{activity}']/../following-sibling::td[1]/input")
          rescue Selenium::WebDriver::Error::NoSuchElementError
          end
        end
        if input
          input.clear
          input.fill(student.grade)
        else
          puts "WARNING: Algo está errado! Talvez o aluno: #{student}; ou a atividade: #{activity} não exista(m)!"
        end
      end
    end
  end
end
