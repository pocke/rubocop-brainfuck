# Rubocop::Brainfuck

A Brainfuck interpreter implementation on RuboCop

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-brainfuck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubocop-brainfuck

## Usage

### Hello world

```ruby
# test.rb
class Program < BrainFuck
  PC = 0
  Code = <<-EOS
    +++++++++[>++++++++>+++++++++++>+++++<<<-]>.>++.+++++++..+++.>-.
    ------------.<++++++++.--------.+++.------.--------.>+.
  EOS
  Memory = []
  Stdout = ''
  Stdin = ''
  Pointer = 0
end
```


```sh
$ rubocop -a -r rubocop/brainfuck --only Brainfuck/Interpreter
$ cat test.rb
# test.rb
class Program < BrainFuck
  PC = 119
  Code = <<-EOS
    +++++++++[>++++++++>+++++++++++>+++++<<<-]>.>++.+++++++..+++.>-.
    ------------.<++++++++.--------.+++.------.--------.>+.
  EOS
  Memory = [0, 72, 100, 33]
  Stdout = "Hello, world!"
  Stdin = ''
  Pointer = 3
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/rubocop-brainfuck.

