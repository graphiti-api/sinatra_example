Graphiti Sinatra Example
========================

Using [Graphiti](https://github.com/graphiti-api/graphiti), Sinatra, and
ActiveRecord with SQLite.

### Running

```bash
$ bundle install
$ bundle exec rackup -p 4567
```

Visit `http://localhost:4567/api/v1/employees`

Currently only serving the [JSONAPI Specification](http://jsonapi.org),
but trivial to add others.
