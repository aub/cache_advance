require File.join(File.dirname(__FILE__), 'spec_helper')

module CacheAdvance
  before :each do
    @cache_set = CacheSet.new
    @mapper = Mapper.new(@cache_set)
  end
  
  describe 'Mapper' do
    it 'should pass qualifiers directly to the cache set' do
      proc = Proc.new { 2 }
      @cache_set.should_receive(:add_qualifier).with(proc)
      @mapper.qualifier(:testy, proc)
    end
  end
end