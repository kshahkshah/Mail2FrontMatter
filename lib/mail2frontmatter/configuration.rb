# Holds configuration and nothing more
module Mail2FrontMatter
  require 'active_support/inflector'

  class << self
    def logger
      @logger
    end

    def config
      @config
    end

    def set_config(passed_config = nil, &block)
      # load config from file
      if passed_config.is_a?(String)
        @config = YAML.load_file(passed_config).deep_symbolize_keys!

      # load config from file at default data/mail2frontmatter.yml relative from run directory
      elsif passed_config.is_a?(NilClass)

        default_config = File.join(Dir.pwd, 'data', 'mail2frontmatter.yml')

        if File.exist?(default_config)
          @config = YAML.load_file(default_config).deep_symbolize_keys!
        else
          raise LoadError, 'no configuration given or found at ./data/mail2frontmatter.yml'
        end

      elsif passed_config.is_a?(Hash)
        @config = passed_config

      else
        raise ArgumentError, 'not a valid configuration type'
      end

      # SET LOG FILE, explicitly
      if @config[:log_file]
        @logger = Logger.new(@config[:log_file])

      # OR USE SOME SENSIBLE DEFAULTS
      elsif Dir.exist?(File.join(Dir.pwd, 'log'))
        @logger = Logger.new(File.join(Dir.pwd, 'log', 'mail2frontmatter.log'))

      else
        @logger = Logger.new(STDOUT)

      end

      # now we yield the config object in case the user would like to overwrite any defaults
      yield(@config) if block_given?

      preprocessors = @config[:preprocessors] || []

      preprocessors.each do |processor|
        begin
          require "mail2frontmatter/#{processor[:key]}"
        rescue LoadError => e
          puts "could not require specified preprocessor '#{processor[:key]}.rb', no such file in load path. Check your configuration and try again \n\n"
          raise e
        end

        klass = "Mail2FrontMatter::#{processor[:key].underscore.camelize}".constantize.register(processor[:options] || {})
      end

    end
  end
end
