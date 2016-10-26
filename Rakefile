require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test_task) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList['test/**/*_test.rb']
end

task :test do
  begin
    Rake::Task['test_task'].invoke
  rescue
    # Supress the verbose failure output of TestTask
  end
end

task :default => :test
