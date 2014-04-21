<p align="center">
  <a href="https://github.com/mirego/microscope">
    <img src="http://i.imgur.com/JMcAStM.png" alt="Microscope" />
  </a>
  <br />
  Microscope adds useful scopes targeting ActiveRecord <code>boolean</code>, <code>date</code> and <code>datetime</code> fields.
  <br /><br />
  <a href="https://rubygems.org/gems/microscope"><img src="https://badge.fury.io/rb/microscope.png" /></a>
  <a href="https://codeclimate.com/github/mirego/microscope"><img src="https://codeclimate.com/github/mirego/microscope.png" /></a>
  <a href='https://coveralls.io/r/mirego/microscope?branch=master'><img src='https://coveralls.io/repos/mirego/microscope/badge.png?branch=master' /></a>
  <a href='https://gemnasium.com/mirego/microscope'><img src="https://gemnasium.com/mirego/microscope.png" /></a>
  <a href="https://travis-ci.org/mirego/microscope"><img src="https://travis-ci.org/mirego/microscope.png?branch=master" /></a>
</p>

---

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'microscope'
```

## Usage

```ruby
create_table "events" do |t|
  t.string   "name"
  t.boolean  "special"
  t.datetime "expired_at"
  t.date     "started_on"
end

class Event < ActiveRecord::Base
  acts_as_microscope
end

Event.special
# SELECT * FROM `events` where `events`.`special` = 1

Event.not_special
# SELECT * FROM `events` where `events`.`special` = 0

Time.now
# => 2013-07-05 15:43:42

Event.expired_before(2.months.ago)
# SELECT * FROM `events` where `events`.`expired_at` < '2013-05-05 15:43:42'

Event.expired_before_now
# SELECT * FROM `events` where `events`.`expired_at` < '2013-07-05 15:43:42'

Event.expired_after_or_at(2.months.from_now)
# SELECT * FROM `events` where `events`.`expired_at` >= '2013-09-05 15:43:42'

Event.expired_between(2.months.ago..1.month.from_now)
# SELECT * FROM `events` where `events`.`expired_at` BETWEEN '2013-05-05 15:43:42' AND '2013-08-05 15:43:42'

Event.started_before(2.days.ago)
# SELECT * FROM `events` where `events`.`started_on` < '2013-07-03'

Event.started_between(2.days.ago..3.days.from_now)
# SELECT * FROM `events` where `events`.`started_on` BETWEEN '2013-07-03' AND '2013-07-08'

Event.started
# SELECT * FROM `events` where `events`.`started_at` IS NOT NULL AND `events`.`started_at` <= '2013-07-05 15:43:42'

Event.not_started
# SELECT * FROM `events` where `events`.`started_at` IS NULL OR `events`.`started_at` > '2013-07-05 15:43:42'
```

Microscope also adds three instance methods to the model per scope.

```ruby
event = Event.started.first
# SELECT * FROM `events` where `events`.`started_at` IS NOT NULL AND `events`.`started_at` <= '2013-07-05 15:43:42' LIMIT 1

event.started? # => true
event.not_started? # => false

event = Event.unstarted.first
event.started? # => false

event.start!
event.started? # => true
event.started_at # => 2013-07-05 15:43:44 (Time.now)
```

### Options

You can use a few options when calling `acts_as_microscope`:

```ruby
class Event < ActiveRecord::Base
  acts_as_microscope, only: [:created_at]
end

class User < ActiveRecord::Base
  acts_as_microscope, except: [:created_at]
end

Event.created_before(2.months.ago) # works!
Event.updated_before(2.months.ago) # NoMethodError

User.created_before(2.months.ago) # NoMethodError
User.updated_before(2.months.ago) # works!
```

## License

`Microscope` is © 2013-2014 [Mirego](http://www.mirego.com) and may be freely distributed under the [New BSD license](http://opensource.org/licenses/BSD-3-Clause).  See the [`LICENSE.md`](https://github.com/mirego/microscope/blob/master/LICENSE.md) file.

The microscope logo is based on [this lovely icon](http://thenounproject.com/noun/microscope/#icon-No9056) by [Scott Lewis](http://thenounproject.com/iconify), from The Noun Project. Used under a [Creative Commons BY 3.0](http://creativecommons.org/licenses/by/3.0/) license.

## About Mirego

[Mirego](http://mirego.com) is a team of passionate people who believe that work is a place where you can innovate and have fun. We're a team of [talented people](http://life.mirego.com) who imagine and build beautiful Web and mobile applications. We come together to share ideas and [change the world](http://mirego.org).

We also [love open-source software](http://open.mirego.com) and we try to give back to the community as much as we can.
