
desc "clean generated site"
task :clean do
  $:.unshift(File.join(File.dirname(__FILE__), '..', 'config'))
  require 'config'
  
  sh %{rm -rf #{AppConfig[:output_directory]}*}
end