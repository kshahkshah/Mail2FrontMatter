[![Build Status](https://travis-ci.org/whistlerbrk/Mail2FrontMatter.svg?branch=master)](https://travis-ci.org/whistlerbrk/Mail2FrontMatter)

# Mail2FrontMatter

Email-to-blog parser which creates YAML FrontMatter and saves your attachments.

Designed to be used with either Middleman or Jekyll.

This project is actively being developed. I wrap the executable with the [eye](https://github.com/kostya/eye) gem at the moment.

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

    $ bundle exec mail2frontmatter

To detach the process pass the ```-d``` option:

    $ bundle exec mail2frontmatter -d

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

There are more configuration options available, most importantly which directory mail2frontmatter will write your blog's ERB/FrontMatter to and which directory it will save attachments. If you are using Middleman and running the executable from your Middleman directory, you likely do not need to set these explicitly.

```yaml
data_directory:  /home/deploy/yoursite/source/blog
media_directory: /home/deploy/yoursite/source
```

media_directory is a base, it will create an images, audio, and videos directory if one does not exist and save attachments there accordingly.

Again, if you are using Middleman, the defaults should work for you.

### Embedded Configuration

As an alternative to using the executable, you may wish to run the watcher (a wrapper around Mailman) embedded within your own code. This may be useful if, for example, you are already running Mailman and don't want to spare the resources or if you need to custom configure Mailman.

Set ```Mail2FrontMatter```'s config by passing it a hash of options (or keep it empty). The constructor also takes a block as shown below. Check out the gem's code for more details.

```ruby
  require 'mail2frontmatter'

  Mail2FrontMatter.set_config({}) do |config|
    config[:mailman] = {
      server: imap.gmail.com
      port: 993
      ssl: true
      username: youruser@yourdomain.com
      password: yourpassword
    }

    config[:receiver] = "yourblog@yourdomain.com"
    config[:senders]  = "youruser@yourdomain.com"
  end

  # run it
  Mail2FrontMatter::Watcher.run
```

### Plugins

If you've released a plugin of your own and would like to add it to this list, please send me a pull request.

[AutoTagSubject](https://github.com/whistlerbrk/m2fm-autotag-subject) - extracts tags from your subject line

[AutomaticEmbeds](https://github.com/whistlerbrk/m2fm-automatic-embeds) - automatically converts links into embeds (e.g. youtube, soundcloud, vimeo, gist)

[AutomaticClowncar](https://github.com/whistlerbrk/m2fm-automatic-clowncar) - makes your incoming image attachments automatic-clowncar compatible (requires Middleman)

### Extending It

Finally you can extend Mail2FrontMatter to further process incoming emails by subclassing ```Mail2FrontMatter::PreProcessor``` and registering it. The plugins above all implement the pattern shown.

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

* core plugins

Core plugins should be included out of the box and disabled upon request. It's just simpler to use

* zero config for Jekyll

current we 'detect' the directory structure to see if the executable is run from Middleman, 
do the same for Jekyll in order to support it out of the box with zero configuration

* remove dependency on Mailman, use Mail directly

no need to use Mailman if I intend to manage the process myself. Use Mail directly

* detach runner

incoming mail checks in the main thread, processing, writing, commiting should be handled in a separate process to discard leaks








