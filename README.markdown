# Flattenator

Converts a deeply nested hash with a flattened hash, prefixing the keys for child hashes. It's easier to show than to explain:

```ruby
# start with this
{
  foo: "bar",
  baz: {
    apple: 2,
    banana: 5,
    carrot: 0,
  },
}
# end with this
{
  "foo" => "bar",
  "baz_apple" => 2,
  "baz_banana" => 5,
  "baz_carrot" => 0,
}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'flattenator'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install flattenator

## Usage

```
Flattenator::Hash.new(hash).flattened
```

By default, a JSON-encoded version of the object being flattened will be included in the flattened hash, but this can be turned off.

```ruby
original = {
  foo: "bar",
  options: {
    jiggle_handle: true,
    tighten_valve: false,
  },
}

Flattenator::Hash.new(original).flattened
{
  "foo" => "bar",
  "options" => "{\"jiggle_handle\":true,\"tighten_valve\":false}"
  "options_jiggle_handle" => true,
  "options_tighten_valve" => false,
}

Flattenator::Hash.new(original, include_unflattened: false).flattened
{
  "foo" => "bar",
  "options_jiggle_handle" => true,
  "options_tighten_valve" => false,
}
```

Additionally, arrays are flattened into the form `{key}_{index}`, like so:

```ruby
original = {
  fruits: [
    "apple",
    "banana",
    "citrus",
  ],
  vegetables: [
    "daikon",
    "eggplant",
  ],
}

Flattenator::Hash.new(original).flattened
{
  "fruits" => "[\"apple\",\"banana\",\"citrus\"]",
  "fruits_0" => "apple",
  "fruits_1" => "banana",
  "fruits_2" => "citrus",
  "vegetables" => "[\"daikon\",\"eggplant\"]",
  "vegetables_0" => "daikon",
  "vegetables_1" => "eggplant",
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/flattenator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/flattenator/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Flattenator project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/flattenator/blob/master/CODE_OF_CONDUCT.md).
