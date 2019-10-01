[![Gem Version](https://badge.fury.io/rb/streakable.svg)](https://badge.fury.io/rb/streakable) [![Build Status](https://travis-ci.org/szTheory/streakable.svg?branch=master)](https://travis-ci.org/szTheory/streakable) [![Coverage Status](https://coveralls.io/repos/github/szTheory/streakable/badge.svg?branch=master)](https://coveralls.io/github/szTheory/streakable?branch=master) [![Inline docs](http://inch-ci.org/github/szTheory/streakable.svg?branch=master)](http://inch-ci.org/github/szTheory/streakable) [![Maintainability](https://api.codeclimate.com/v1/badges/cacc27fc37181c331918/maintainability)](https://codeclimate.com/github/szTheory/streakable/maintainability) [![MIT License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/szTheory/streakable/blob/master/LICENSE.txt) [![Gem](https://img.shields.io/gem/dt/streakable.svg)](https://rubygems.org/gems/streakable) [![GitHub stars](https://img.shields.io/github/stars/sztheory/streakable.svg?label=Stars&style=social)](https://github.com/szTheory/streakable)

![Streakable Logo](https://user-images.githubusercontent.com/28652/49296229-aa500a00-f485-11e8-8f13-51f2ad326e5c.png)

Streakable is a Ruby gem to track consecutive day streaks :calendar: on your Rails/ActiveRecord models. Hard fork of [has_streak](https://github.com/garrettqmartin8/has_streak) by Garrett Martin with a different include interface and more features. Requires Ruby >= 2.1 and ActiveRecord >= 3.2.22.

[Github Project Page](https://github.com/szTheory/streakable)

## Installation

Add this line to your application's Gemfile:

    gem 'streakable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install streakable

## Usage

Let's say I have a <code>User</code> that <code>has_many</code> posts:

```ruby
class User < ActiveRecord::Base
  has_many :posts
end
```

I want to track how many days in a row that each user wrote a post. I just have to include <code>streakable</code> in the model:

```ruby
class User < ActiveRecord::Base
  include Streakable
end
```

Now I can display the user's streak:

```ruby
user.streak(:posts) # => number of days in a row that this user wrote a post (as determined by the created_at column, by default)
```

The <code>streak</code> instance method can be called with any association:

```ruby
user.streak(:other_association)
```

And you can change the column the streak is calculated on:

```ruby
user.streak(:posts, :updated_at)
```

Don't penalize the current day being absent when determining streaks (the User could write another Post before the day ends):

```ruby
user.streak(:posts, except_today: true)
```

Find the longest streak, not just the current one:

```ruby
user.streak(:posts, longest: true)
```

To get all of the streaks, not just the current one:

```ruby
user.streaks(:posts)
```

## TODO

* Add class methods/scopes for calculating streaks on records not in memory

## Specs
To run the specs for the currently running Ruby version, run `bundle install` and then `bundle exec rspec`. To run specs for every supported version of ActionPack, run `bundle exec appraisal install` and then `bundle exec appraisal rspec`.

## Gem release
Make sure the specs pass, bump the version number in streakable.gemspec, build the gem with `gem build streakable.gemspec`. Commit your changes and push to Github, then tag the commit with the current release number using Github's Releases interface (use the format vx.x.x, where x is the semantic version number). You can pull the latest tags to your local repo with `git pull --tags`. Finally, push the gem with `gem push streakable-version-number-here.gem`.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`) or bugfix branch (`git checkout -b bugfix/my-helpful-bugfix`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Make sure specs are passing (`bundle exec rspec`)
6. Create new Pull Request

## License

See the [LICENSE](https://github.com/szTheory/streakable/blob/master/LICENSE.txt) file.