
# Writes YAML FrontMatter & Article Content
module Mail2FrontMatter
  class Writer

    require 'yaml'
    require 'active_support/inflector'

    def self.write(metadata, body)

      # TODO FIXME! this is supposed to be configurable!
      data_directory = File.join(Dir.pwd, 'source', 'blog')

      # TODO NO NO! this is supposed to happen in a pre-processor!
      # FINE AS A DEFAULT BUT SHOULDNT HAPPEN HERE
      filename = [metadata[:received].strftime("%Y-%m-%d"), '-', metadata[:subject].parameterize, '.html.erb'].join

      # TODO/FIXME/QUESTION - questionable inner_html call?
      data = metadata.to_yaml + "---\n" + body.inner_html

      File.write(File.join(data_directory, filename), data)
    end

  end
end
