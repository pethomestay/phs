begin
  require 'rspec/core/rake_task'

  namespace :spec do
    desc "Run tests with coverage check"
    task :covered do
      ENV['RSPEC_COVERED'] = '1'
      Rake::Task['spec'].execute
    end
  end
rescue MissingSourceFile
  #Nevermind
end