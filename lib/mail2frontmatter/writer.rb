
# Writes YAML FrontMatter & Article Content in ERB
# 
# TODO How do I support other templating solutions here?
#      Same plugin style as processors?
#      Is processor and writer doing the same thing?
#       --- probably just let anyone specify the extension.. keep it simple
# 
module Mail2FrontMatter
  class Writer

    require 'yaml'
    require 'active_support/inflector'

    def self.write(metadata, body)
      # MAPPINGS!
      # 
      # Play nice with programs which will read this data
      # And set sensible defaults as fall throughs

      # if there is no title set, borrow the subject lines
      metadata[:title] ||= metadata[:subject]

      # make a sensible standard blog filename unless one is given
      metadata[:filename] ||= [metadata[:received].strftime("%Y-%m-%d"), '-', metadata[:subject].parameterize, '.html.erb'].join

      data = metadata.to_yaml + "---\n" + body

      File.write(File.join(Mail2FrontMatter.config[:data_directory], metadata[:filename]), data)
    end

  end
end
