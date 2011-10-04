
# load external rake files
Dir.glob("tasks/*.rake").each do |task| 
  import task
end


task :default => [:run]

desc "generate the site"
task :run do
  begin
    sh %{ruby -w oven.rb}
  rescue
    puts "Error executing Rake task :run"
  end
end

desc "clean generated site"
task :clean do
  $:.unshift(File.join(File.dirname(__FILE__), 'config'))
  require 'config'
  
  sh %{rm -rf #{AppConfig[:output_directory]}}
end

desc "runs rspec:all"
task :test do
  Rake::Task['rspec:all'].invoke()
end

