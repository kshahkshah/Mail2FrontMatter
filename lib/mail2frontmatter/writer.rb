
# Writes YAML FrontMatter & Article Content in ERB
# 
# TODO How do I support other templating solutions here?
#      Same plugin style as processors?
#      Is processor and writer doing the same thing?
# 
module Mail2FrontMatter
  class Writer

    require 'yaml'
    require 'active_support/inflector'

    def self.write(metadata, body)

      # TODO FIXME!
      # 
      # this is supposed to be configurable!
      # get this value from a module variable!
      # 
      data_directory = File.join(Dir.pwd, 'source', 'blog')

      # MAPPINGS!
      # 
      # Play nice with programs which will read this data
      # And set sensible defaults as fall throughs

      # if there is no title set, borrow the subject lines
      metadata[:title] ||= metadata[:subject]

      # make a sensible standard blog filename unless one is given
      metadata[:filename] ||= [metadata[:received].strftime("%Y-%m-%d"), '-', metadata[:subject].parameterize, '.html.erb'].join

      # a processor can remove and rearrange nodes, stripping out extraneous html
      # but there should always be a root body node so we can call #inner_html on it
      data = metadata.to_yaml + "---\n" + body.inner_html

      File.write(File.join(data_directory, metadata[:filename]), data)
    end

  end
end
