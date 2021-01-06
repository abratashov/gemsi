## Gemsi
Gemsi - is a command-line tool that shows in a convenient way the descriptions of every gem from the Gemfile.

#### Installation
`gem install gemsi`

#### Using
Before running you have to run `bundle install` for fetching all gems from your `Gemfile` and then run `gemsi`, example output:
```
rails
                               5.0.7.2
                               Ruby on Rails is a full-stack web framework optimized for programmer happiness a
                               nd sustainable productivity. It encourages beautiful code by favoring convention
                                over configuration. Full-stack web application framework.

                               http://rubyonrails.org
                               https://github.com/search?q=rails&ref=cmdform
                               # Loads environment variables from `.env`

modernizr-rails
                               2.7.1
                               This Modernizr.js was built using the at http://www.modernizr.com/download/ with
                                all options enabled. Gem wrapper to include the Modernizr.js library via the as
                               set pipeline.

                               http://rubygems.org/gems/modernizr-rails
                               https://github.com/search?q=modernizr-rails&ref=cmdform
numeraljs-rails
                               1.4.5.0
                               A javascript library for formatting and manipulating numbers. Numeral.js

                               http://numeraljs.com/
                               https://github.com/search?q=numeraljs-rails&ref=cmdform

active_model_serializers
                               0.10.10
                               ActiveModel::Serializers allows you to generate your JSON in an object-oriented
                               and convention-driven manner. Conventions-based JSON generation for Rails.

                               https://github.com/rails-api/active_model_serializers

jsonapi-serializer
                               2.1.0
                               Fast, simple and easy to use JSON:API serialization library (also known as fast_
                               jsonapi). Fast JSON:API serialization library

                               https://github.com/jsonapi-serializer/jsonapi-serializer


                               # bundle exec rake doc:rails generates the API under doc/api.

pg_search
                               2.3.0
                               PgSearch builds Active Record named scopes that take advantage of PostgreSQL's f
                               ull text search

                               https://github.com/Casecommons/pg_search

```
