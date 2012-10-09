
desc "clean generated site"
task :clean do
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'config'))
  require 'config'
  
  dir = AppConfig[:output_directory]
  
  if dir.nil? || dir.trim().size < 2
    puts "No output directory to clean"
  else
    sh %{rm -rf #{dir}*}
  end
end