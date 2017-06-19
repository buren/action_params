# ActionParams

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'action_params'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install action_params

## Usage

```ruby
# Example users controller

# List all valid attributes
ATTRIBUTES = [
  {
    name: :first_name,
    type: String,
    required_on: [:create],
    description: 'First name of user'
  },
  {
    name: :gender,
    type: String,
    required_on: [:create],
    description: 'Gender',
    one_of: %w(Male Female Other)
  },
  {
    name: :arrived_at,
    type: DateTime,
    description: 'Arrival time'
  },
  {
    name: :public_profile,
    type: :boolean,
    description: 'Arrival time'
  },
  {
    name: :password,
    type: Hash,
    description: 'Password entity',
    exists_on: [:create],
    children: [
      {
        name: :current,
        type: String,
        description: 'Current password'
      },
      {
        name: :next,
        type: String,
        description: 'Next password'
      }
    ]
  },
  {
    name: :interest_ids,
    type: Hash,
    description: 'List of interest_ids',
    children: [
      {
        name: :id,
        type: String,
        description: 'Interest ID'
      },
      {
        name: :level,
        type: Integer,
        description: 'Interest level',
        one_of: 1..5
      }
    ]
  },
  {
    name: :ignored_notifications,
    type: Array,
    of: String,
    description: 'Ignored notifications'
  }
].freeze

# Nest the attributes under data/attributes
PARAMS_TREE = {
  type: Hash,
  name: :data,
  children: [{
    type: Hash,
    name: :attributes,
    children: ATTRIBUTES
  }]
}.freeze
```

__Then in the controller you can generate the docs with__:

```ruby
ActionParams::Apipie.generate(
  self,
  :create,
  AttributesTree.build(PARAMS_TREE)
)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/buren/action_params.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
