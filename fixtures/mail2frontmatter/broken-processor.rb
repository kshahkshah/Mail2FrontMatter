module Mail2FrontMatter
  class BrokenProcessor < PreProcessor
    def self.run(metadata, body)
      fail NoMethodError, 'because this is a test'
      [metadata, body]
    end
  end
end

Mail2FrontMatter::BrokenProcessor.register
