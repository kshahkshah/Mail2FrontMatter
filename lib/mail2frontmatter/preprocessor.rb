
# Pre-processes blog data, allows hooks
# 
# 
# Build a Pre-Processor that accepts two arguments
# metadata, a symbolized hash of metadata extracted from the email
# and body, a Nokogiri parsed representation of the email
# 
# modify as necessary and as atomically as possible and return two arguments
# 
# example:
# 
# class MyPreProcessor
#   extend Mail2FrontMatter::PreProcessor
# 
#   def self.run(metadata, body)
#     metadata[:subject] = some_transformation(metadata[:subject])
# 
#     return metadata, body
#   end
# end

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
