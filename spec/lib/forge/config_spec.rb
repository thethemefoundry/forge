
require 'forge/config'

describe Forge::Config do

  def config_file
    File.expand_path(File.join('~', '.forge', 'config.yml'))
  end

  before(:each) do
    @buffer = StringIO.new
    @config = Forge::Config.new
  end

  it "should provide empty config object by default" do
    @config.config.should == {
      :theme => {
        :author    => nil,
        :author_url => nil
      },
      :links => []
    }
  end

  it "should allow access to config variables through []" do
    @config[:links].should == []
  end

  it "should allow config options to be changed through []" do
    @config[:links] = ['/var/www/wordpress']
    @config[:links].should == ['/var/www/wordpress']
  end

  it "should store config in ~/.forge/config.yml" do
    @config.config_file.should == config_file
  end

  it "should write default configuration to yaml" do
    @config.write(:io => @buffer)
    @buffer.string.should == "---\n:theme:\n  :author: !!null \n  :author_url: !!null \n:links: []\n"
  end

  describe :write do
    it "should dump any changes made to the config" do
      @config[:theme][:author] = "Matt Button"
      @config[:theme][:author_url] = "http://that-matt.com"

      @config.write(:io => @buffer)
      @buffer.string.should == "---\n:theme:\n  :author: Matt Button\n  :author_url: http://that-matt.com\n:links: []\n"
    end
  end

  describe :read do
    it "should call #write if the file does not exist" do
      File.should_receive(:exists?).with(config_file).and_return(false)
      Psych.should_not_receive(:load_file)

      @config.should_receive(:write)
      @config.read
    end

    it "should not call #write if the config file exists" do
      File.should_receive(:exists?).with(config_file).and_return(true)
      Psych.should_receive(:load_file).with(config_file)

      @config.should_not_receive(:write)
      @config.read
    end

    it "should load config from yaml file" do
      File.stub!(:exists?).and_return(true)
      Psych.stub!(:load_file).and_return({:theme => {:author => 'Drew'}, :links => []})

      @config.read
      @config[:links].should == []
      @config[:theme].should == {:author => 'Drew'}
    end
  end
end
