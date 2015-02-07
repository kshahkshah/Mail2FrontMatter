module Mail2FrontMatter
  class FakeProcessorWithOptions < PreProcessor
    def self.run(metadata, body)
      [metadata, body]
    end
  end
end

Mail2FrontMatter::FakeProcessorWithOptions.register
