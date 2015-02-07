require 'spec_helper'

describe Mail2FrontMatter, 'configuration' do
  let(:simple_config)    { File.join(M2FM_GEM_PATH, 'fixtures', 'mail2frontmatter.simple.yml') }
  let(:complex_config)   { File.join(M2FM_GEM_PATH, 'fixtures', 'mail2frontmatter.complex.yml') }
  let(:malformed_config) { File.join(M2FM_GEM_PATH, 'fixtures', 'mail2frontmatter.malformed.yml') }

  it 'should load a configuration by passing a YAML file location' do
    expect do
      Mail2FrontMatter.set_config(simple_config)
    end.to_not raise_error
  end

  it 'should load a configuration by passing a hash' do
    expect do
      Mail2FrontMatter.set_config(foo: 'bar')
    end.to_not raise_error
  end

  it 'should raise an error for other types' do
    expect do
      Mail2FrontMatter.set_config([])
    end.to raise_error
  end

  it 'should fail loading malformed configs' do
    expect do
      Mail2FrontMatter.set_config(malformed_config)
    end.to raise_error
  end

  it 'should attempt to load the default configuration if nothing is passed' do
    # this should attempt and fail because there is no ./data/mail2frontmatter.yml
    expect do
      Mail2FrontMatter.set_config do |config|
        config[:foo] = 'bar'
      end
    end.to raise_error(LoadError)
  end
end
