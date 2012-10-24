require 'cgi'
require 'capybara/dsl'
class Capybara::Jasmine::TestTask
  attr_accessor :lib_files, :spec_files
  include Capybara::DSL

  def initialize(*args)
    yield self
    Rake::Task.define_task(*args) do
      Capybara.app = Runner.new(lib_files + spec_files)
      Capybara.current_driver = Capybara.javascript_driver
      visit '/'
      wait_until { evaluate_script "window.reporter && window.reporter.done" }
      success = evaluate_script "window.reporter.clean"
      output = evaluate_script "window.reporter.output"
      output = CGI.unescape(output)
      if !success
        $stderr.puts errors
        exit(1)
      else
        $stdout.puts output
      end
    end
  end


  class Runner
    def initialize(files)
      @files = files
    end
    def call(env)
      path = env['REQUEST_PATH'][1..-1]
      case path
      when ''
        template = File.read(File.join(File.dirname(__FILE__), 'SpecRunner.html'))
        template.gsub!("{{SCRIPTS}}", script_tags)
        [200, {'Content-Type' => 'text/html'}, [template.to_s]]
      when 'jasmine.js'
        jasmine = File.read(File.join(File.dirname(__FILE__), 'jasmine.js'))
        [200, {'Content-Type' => 'text/javascript'}, [jasmine.to_s]]
      when 'capybara_reporter.js'
        jasmine = File.read(File.join(File.dirname(__FILE__), 'capybara_reporter.js'))
        [200, {'Content-Type' => 'text/javascript'}, [jasmine.to_s]]
      else
        if @files.include? path
          data = File.read(path)
          [200, {'Content-Type' => 'text/javascript'}, [data]]
        else
          [404, {}, []]
        end
      end
    end

    def script_tags
      @files.map{|f| script_tag(f) }.join("\n")
    end

    def script_tag(file)
      %{<script src="#{file}"></script>}
    end
  end
end