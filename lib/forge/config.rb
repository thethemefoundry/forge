module Forge
  # Reads/Writes a configuration file in the user's home directory
  #
  class Config

    @config

    attr_accessor :config

    def initialize()
      @config = {
        :theme => {
          :author     => nil,
          :author_url => nil,
        },
        :links => []
      }
    end

    # Provides access to the config using the Hash square brackets
    def [](var)
      @config[var]
    end

    # Allows modifying variables through hash square brackets
    def []=(var, value)
      @config[var] = value
    end

    # Returns the path to the user's configuration file
    def config_file
      @config_file ||= File.expand_path(File.join('~', '.forge', 'config.yml'))
    end

    # Writes the configuration file
    def write(options={})
      # If we're unit testing then it helps to use a
      # StringIO object instead of a file buffer
      io = options[:io] || File.open(self.config_file, 'w')

      io.write JSON.generate(@config)

      io.close

      self
    end

    # Loads config declarations in user's home dir
    #
    # If file does not exist then it will be created
    def read
      return write unless File.exists?(self.config_file)

      data = File.open(self.config_file).read

      @config = data.empty? ? {} : JSON.parse(data)

      self
    end
  end
end
