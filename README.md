[![Gem Version](https://badge.fury.io/rb/streakable.svg)](https://badge.fury.io/rb/streakable) [![Build Status](https://travis-ci.org/szTheory/streakable.svg?branch=master)](https://travis-ci.org/szTheory/streakable) ![GitHub](https://img.shields.io/github/license/mashape/apistatus.svg)

# Streakable

Track consecutive day streaks on your ActiveRecord models. Fork of [has_streak](https://github.com/garrettqmartin8/has_streak) by Garrett Martin. This version has a different include interface and more options.

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
  # ...

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See the [LICENSE](https://github.com/szTheory/streakable/blob/master/LICENSE.txt) file.