module Mail2FrontMatter
  class FakeProcessor < PreProcessor
    def self.run(metadata, body)
      [metadata, body]
    end
  end
end

Mail2FrontMatter::FakeProcessor.register
