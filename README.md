# Cacchern

operate Redis like ActiveRecord interface

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cacchern'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cacchern

## Usage

1. Create classes

Create a class that overrides Cacchern::Value

```ruby
class Score < Cacchern::Value
  validates :key, presence: true, numericality: { only_integer: true }
  validates :value, presence: true, numericality: true
end
```

Create a class that overrides Cacchern::Value

```ruby
class ScoreSet < Cacchern::SortedSet
  contain_class Score
end
```

2. Add value

```ruby
base_set = ScoreSet.new('base')
#=> #<ScoreSet:0x000056544559a520 @key="score_set:base">
score = Score.new(1, 100)
#=> #<Score:0x00005654456194b0
# @errors=#<ActiveModel::Errors:0x0000565445619050 @base=#<Score:0x00005654456194b0 ...>, @details={}, @messages={}>,
# @key=1,
# @validation_context=nil,
# @value=100>
base_set.add(score)
base_set.add(Score.new(2,50))

base_set.add_all([Score.new(3,50),Score.new(4,40)])
```


3. Get Values

```ruby
base_set.order(:desc)
#=> [#<Score:0x000056544570ebb8
#  @errors=#<ActiveModel::Errors:0x000056544570ea28 @base=#<Score:0x000056544570ebb8 ...>, @details={}, @messages={}>,
#  @key="1",
#  @validation_context=nil,
#  @value=100.0>,
# #<Score:0x000056544570e230
#  @errors=#<ActiveModel::Errors:0x000056544570e0a0 @base=#<Score:0x000056544570e230 ...>, @details={}, @messages={}>,
#  @key="2",
#  @validation_context=nil,
#  @value=50.0>]
```

```ruby
base_set.order(:asc)
#=> [#<Score:0x000056544579aaa0
#  @errors=#<ActiveModel::Errors:0x000056544579a910 @base=#<Score:0x000056544579aaa0 ...>, @details={}, @messages={}>,
#  @key="2",
#  @validation_context=nil,
#  @value=50.0>,
# #<Score:0x000056544579a168
#  @errors=#<ActiveModel::Errors:0x0000565445799fd8 @base=#<Score:0x000056544579a168 ...>, @details={}, @messages={}>,
#  @key="1",
#  @validation_context=nil,
#  @value=100.0>]
```

4. Remove value

```ruby
base_set.remove(2)
#=> true
base_set.order(:asc)
#=> [#<Score:0x0000565445850990
#  @errors=#<ActiveModel::Errors:0x0000565445850800 @base=#<Score:0x0000565445850990 ...>, @details={}, @messages={}>,
#  @key="1",
#  @validation_context=nil,
#  @value=100.0>]
base_set.remove_all 
```

- IncrementableSortedSet

```ruby
class IScoreSet < Cacchern::IncrementableSortedSet
  contain_class Score
end
```

```ruby
base_set = IScoreSet.new('base')
base_set.add(Score.new(2,50))
base_set.increment(Score.new(2,50))
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/shuyuhey/cacchern.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
