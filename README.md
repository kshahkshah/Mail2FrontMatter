# Mail2FrontMatter

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

To run in the foreground:

    $ mail2frontmatter

To detach the process pass the ```-d``` option:

    $ mail2frontmatter -d

```mail2frontmatter``` assumes a configuration file will be present at ```./data/mail2frontmatter.yml```

You can override this by passing ```--config=CONFIG```

Furthermore, when run daemonized ```mail2frontmatter``` assumes it can:

1. write its pidfile to ```./tmp/pids/mail2frontmatter.pid```
2. append its log output to ```./log/mail2frontmatter.log```

You can override each of these settings as well:

To specify a pidfile location set ```--pid=PIDFILE```
Note: no pidfile is written when run in the foreground

To specify a log file location set ```--log=LOGFILE```
The default log file when detached is ```./log/mail2frontmatter.log``` (otherwise its ```STDOUT```)

Finally to stop (```SIGTERM```) the detached process call:

    $ mail2frontmatter -k

### Basic Configuration

Your configuration file should by parseable YAML. 

```yaml
protocol: imap
receiver: yourblogemail@yourdomain.com
senders:  yourpersonal@yourdomain.com
mailman:
  server: imap.gmail.com
  port: 993
  ssl: true
  username: yourblogemail@yourdomain.com
  password: yourpassword
```

As shown the mailman configuration are the exact options you would pass [to that gem](https://github.com/titanous/mailman/blob/master/USER_GUIDE.md).

### Embedded Configuration

As an alternative to using the executable, you may wish to run the watcher (a wrapper around Mailman) embedded within your own code. This may be useful if you are already running Mailman and don't want to spare the resources or if you need to custom configure Mailman.

Instantiate ```Mail2FrontMatter::Watcher``` and pass it a configuration hash (or keep it empty). The constructor takes a block in which you can directly access the Mailman object as well. See the example below or check out the gem's code directly.

```ruby
  require 'mail2frontmatter'

  watcher = Mail2FrontMatter::Watcher.new({}) do |config|
    config[:mailman] = {
      server: imap.gmail.com
      port: 993
      ssl: true
      username: youruser@yourdomain.com
      password: yourpassword
    }

    config[:receiver] = "yourblog@yourdomain.com"
    config[:senders] = "youruser@yourdomain.com"

    ....
  end

  # run it
  watcher.run
```

### Extending It

Finally you can extend Mail2FrontMatter to further process incoming emails by subclassing ```Mail2FrontMatter::PreProcessor``` and registering it.

for example:

```ruby
module Mail2FrontMatter
  class MyProcessor < PreProcessor
    def self.run(metadata, body)
      metadata[:some_field] = some_transformation_of(metadata[:some_field])
      return metadata, body
    end
  end
end

Mail2FrontMatter::MyProcessor.register
```

You should always always return metadata and body as shown since this will be passed onto other processors in the chain.

## Contributing

1. Fork it ( https://github.com/whistlerbrk/mail2frontmatter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### TODO

* White list sanitization!
* Mail2FrontMatter::Watcher handles both configuration for the whole shebang as well as Mailman. Should be split
* Some options intended to be configurable (media directory, etc) are not yet and essentially mean you can only run this from a middleman directory installation atm.