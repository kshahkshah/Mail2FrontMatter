
# Pre-processes blog data, allows hooks

module Mail2FrontMatter
  class PreProcessor
    require 'set'

    class InvalidProcessor < StandardError ; end

    @@processors = Set.new

    def self.register(options = {})
      raise InvalidProcessor, "run method not defined on #{self}" if !self.respond_to?(:run)
      @options = options

      @@processors << self
    end

    def self.process(metadata, body)
      @@processors.each do |processor|
        metadata, body = processor.run(metadata, body)
      end

      return metadata, body
    end

  end
end
