# Mail2FrontMatter

Under development!

Email-to-blog parser which creates YAML FrontMatter and saves your attachments.

Designed to be used with either Middleman or Jekyll

## Installation

Install it yourself as:

    $ gem install mail2frontmatter

Or if you do not intend to directly use the executable, you can include it in Gemfile like:

```ruby
gem 'mail2frontmatter'
```

And then execute:

    $ bundle

## Usage

The executable ```mail2frontmatter``` will by default look for a configuration file in ```data/mail2frontmatter.yml``` relative to the current directory by default. You can override this by passing a path to a config file like:

    $ mail2frontmatter -c data/myconfig.yml

Other Flags




Additionally you can daemonize the process by passing the ```-d``` option (TODO)

### Configuration

Your configuration file should by parseable YAML. 

```yaml
protocol: imap
receiver: stream@kunalashah.com
senders:  me@kunalashah.com
mailman:
  server: imap.gmail.com
  port: 993
  ssl: true
  username: youruser@yourdomain.com
  password: yourpassword
```

As shown the mailman configuration are the exact options you would pass to that gem.

## Contributing

1. Fork it ( https://github.com/whistlerbrk/mail2frontmatter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
