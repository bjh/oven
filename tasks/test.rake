namespace :rspec do
  desc "runs rspec --c -f d"
  task :all do
    sh %{rspec specs -c -f d}
  end
end