# chef-recipe

This gem installs chef-recipe, a command-line to help you start
learning Chef as quickly as possible. This is an education tool meant
to new Chef users started as quickly as possible.

## Installation

Add this line to your application's Gemfile:

    gem 'chef-recipe'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chef-recipe

## Usage

Execute the chef-recipe command as follows. You may need to execute it
using sudo.

`sudo chef-recipe RECIPE_FILE`

The Recipe can contain any valid Chef resources. Here is a very simple
example recipe

```Ruby

file "/tmp/foobar.log" do
  content <<-EOF
  hello world!
EOF
end

link "/tmp/foobar.link" do
  to "/tmp/foobar.log"
end

```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authorship

This gem is based on a [gist](https://gist.github.com/2920702) written
by the awesome Daniel DeLeo.
