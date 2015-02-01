module Mail2FrontMatter
  class FakeProcessor < PreProcessor
    def self.run(metadata, body)
      return metadata, body
    end
  end
end

Mail2FrontMatter::FakeProcessor.register
