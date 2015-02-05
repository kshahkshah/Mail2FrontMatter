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

      # setup logger, use provided location
      if @config[:log_file]
        @logger = Logger.new(@config[:log_file])

      # or a sensible default if non was provided
      elsif Dir.exist?(File.join(Dir.pwd, 'log'))
        @logger = Logger.new(File.join(Dir.pwd, 'log', 'mail2frontmatter.log'))

      # finally fallback onto STDOUT
      else
        @logger = Logger.new(STDOUT)
      end

      @config[:git] ||= {
        path:  Dir.pwd
      }

      # set default for data directory unless already specified
      # the data directory is where the posts will be written to
      unless @config[:data_directory]
        # TODO
        # if middleman?
        @config[:data_directory] = File.join(Dir.pwd, 'source', 'blog')
        # elsif jekyll?
        # else
        # end
      end

      # set default for media directory unless already specified
      # the media directory is where the attachments will be saved to
      unless @config[:media_directory]
        # TODO
        # if middleman?
        @config[:media_directory] = File.join(Dir.pwd, 'source')
        # elsif jekyll?
        # else
        # end
      end

      # now we yield the config object in case the user would like to overwrite any defaults
      yield(@config) if block_given?

      # finally, if pre-processors were specified, we can try requiring them
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
