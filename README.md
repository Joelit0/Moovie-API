# Moovie-API
### Initial setup
##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [2.7.1](https://www.ruby-lang.org/en/news/2020/03/31/ruby-2-7-1-released/)
- Rails [6.0.2.2](https://rubygems.org/gems/rails/versions/6.0.2.2)
- PostgreSQL: [Download here](https://www.postgresql.org/download/)
    

When you install everything, run the PostrgeSQL server.

##### 1. Check out the repository

```bash
git clone git@github.com:JoelAlayon123/Moovie-API.git; cd Moovie-API
```
##### 2. Install dependencies

Run the following commands to install the gems.

```bash
bundle install
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:setup
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

### Tests

##### 1. Run tests

Run the following commands to run tests.

```ruby
bundle exec rspec
```

And you should receive:

```bash
196 examples, 0 failures
```
