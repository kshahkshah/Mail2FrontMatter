# Pre-processes blog data, allows hooks

module Mail2FrontMatter
  class PreProcessor
    require 'set'

    class InvalidProcessor < StandardError; end

    @@processors = Set.new

    def self.processors
      @@processors
    end

    def self.register(options = {})
      fail InvalidProcessor, "run method not defined on #{self}" unless self.respond_to?(:run)
      fail ArgumentError, 'options must be a hash' unless options.is_a? Hash
      @options = options

      @@processors << self
    end

    def self.process(metadata, body)
      @@processors.each do |processor|
        begin
          metadata, body = processor.run(metadata, body)
        rescue StandardError => e
          Mail2FrontMatter.logger.error('processor failed!')
          Mail2FrontMatter.logger.error(e)
        end
      end

      [metadata, body]
    end
  end
end
