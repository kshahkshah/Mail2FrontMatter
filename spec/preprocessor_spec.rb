require 'spec_helper'

describe Mail2FrontMatter::PreProcessor do
  let(:simple_config)  { File.join(M2FM_GEM_PATH, 'fixtures', 'mail2frontmatter.simple.yml') }
  let(:complex_config) { File.join(M2FM_GEM_PATH, 'fixtures', 'mail2frontmatter.complex.yml') }
  let(:broken_config)  { File.join(M2FM_GEM_PATH, 'fixtures', 'mail2frontmatter.broken.yml') }

  let(:message_one) { Mail::Message.new(File.read(File.join(M2FM_GEM_PATH, 'fixtures', 'attachments.eml'))) }

  let(:invalidly_defined_preprocessor) do
    class MyInvalidProcessor < Mail2FrontMatter::PreProcessor
      # note, instanced not class
      def run(metadata, body)
        # some modification
        [metadata, body]
      end
    end

    return MyInvalidProcessor
  end

  let(:validly_defined_preprocessor) do
    class MyValidProcessor < Mail2FrontMatter::PreProcessor
      def self.run(metadata, body)
        # some modification
        [metadata, body]
      end
    end

    return MyValidProcessor
  end

  context 'registration' do
    it 'should raise errors for invalid processors' do
      expect do
        invalidly_defined_preprocessor.register({})
      end.to raise_error
    end

    it 'should not raise errors for valid processors' do
      expect do
        validly_defined_preprocessor.register({})
      end.to_not raise_error
    end

    it 'should raise an error when registered without a hash' do
      expect do
        validly_defined_preprocessor.register(nil)
      end.to raise_error(ArgumentError)
    end

    it 'should not raise an error when registered with a hash' do
      expect do
        validly_defined_preprocessor.register(foo: 'bar')
      end.to_not raise_error
    end

    it 'should load preprocessors' do
      Mail2FrontMatter.set_config(complex_config)
      processors = Mail2FrontMatter::PreProcessor.processors

      expect(processors).to include(Mail2FrontMatter::FakeProcessor)
      expect(processors).to include(Mail2FrontMatter::FakeProcessorWithOptions)
    end

    it 'should provide preprocessors with passed options' do
      Mail2FrontMatter.set_config(complex_config)
      options = Mail2FrontMatter::FakeProcessorWithOptions.instance_variable_get(:@options)

      expect(options.class).to eq(Hash)
      expect(options[:foo]).to eq('bar')
    end
  end

  context 'operation' do
    it 'should continue processing if an individual processor fails' do
      Mail2FrontMatter.set_config(broken_config)
      parser = Mail2FrontMatter::Parser.new(message_one)

      expect do
        Mail2FrontMatter::PreProcessor.process(parser.metadata, parser.body)
      end.to_not raise_error
    end
  end
end
