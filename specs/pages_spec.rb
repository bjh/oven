['config', 'lib'].each do |path|
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', path))
end

require 'pages'

describe DSL::Pages do
  before(:all) do
  end
  
  it 'loves itself' do
  end
end

