module Mail2FrontMatter
  class BrokenProcessor < PreProcessor
    def self.run(metadata, body)
      raise NoMethodError, "because this is a test"
      return metadata, body
    end
  end
end

Mail2FrontMatter::BrokenProcessor.register
