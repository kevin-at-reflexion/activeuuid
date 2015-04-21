 activeuuid
============

_MIT License_ forked from [jashmenn/activeuuid](https://github.com/jashmenn/activeuuid)

Add `binary(16)` UUIDs to ActiveRecord.

## Installation

Add the following to your application's Gemfile:

    gem 'activeuuid', git: 'https://github.com/reflexionhealth/gem-activeuuid.git', branch: 'master'

## Example

#### Create a Migration

`activeuuid` adds the `uuid` type to your migrations. Example:

```ruby
class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails, :id => false  do |t|
      t.uuid :id, :primary_key => true
      t.uuid :sender_id  # belongs_to :sender

      t.string :subject
      t.text :body

      t.timestamp :sent_at
      t.timestamps
    end
    add_index :emails, :id
  end

  def self.down
    drop_table :emails
  end
end
```

#### Include in Model

```ruby
class Email < ActiveRecord::Base
  include ActiveUUID::Attributes
  belongs_to :sender
end
```

#### Example Usage
Here are some example specs:

```ruby
require 'spec_helper'

describe Email do

  context "when using uuid's as keys" do
    let(:guid) { "1dd74dd0-d116-11e0-99c7-5ac5d975667e" }
    let(:email) { Fabricate :email }

    it "the id guid should be equal to the uuid" do
      email.id.to_s.should eql(guid)
    end

    it "should be able to find an email by the uuid" do
      Email.find(guid).id.to_s.should == guid
    end

  end
end
```

## Why the Fork?

This is just a version of activeuuid with customized tweaks for **reflexionhealth**'s needs.
As the author of the customizations, I wanted to leave any changes open source in case
they were useful to someone else.

This repository is a strict downstream of jashmenn's `activeuuid`, and I'll update it whenever I
notice the original gem has been changed (for features/bugfixes or for a new version of `rails`).

### Changes

 + The fork includes a `LazyUUID` class which is initialized instead of `UUIDTools::UUID`.
   Frequently, ids only need to be compared, which is faster without parsing.
   See `lib/activeuuid/lazy.rb`.

 + Serializing the empty string raises an error instead of returning nil.

 + `UUID#to_param` and `#to_json` use dashes instead of plain hex.
   Mostly this is so it is easy to distinguish between UUIDs and other hexadecimal encoded values.

 + To keep things as small as possible, the fork supports less versions of Rails,
   and the fork removes `#natural_key`, `#namespace`, and other alternate generation options.


## Dependencies
rails >= 4.2.0
uuidtools >= 2.1.5

## Authors

- Nate Murray
- pyromaniac
- Andrew Kane
- Devin Foley
- Arkadiy Zabazhanov
- Jean-Denis Koeck
- Florian Staudacher
- Schuyler Erle
- Florian Schwab
- Thomas Guillory
- Daniel Blanco Rojas
- Olivier Amblet
- Kevin Stenerson
