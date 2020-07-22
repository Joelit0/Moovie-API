# Moovie-API
### Initial setup
##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [2.7.1](https://www.ruby-lang.org/en/news/2020/03/31/ruby-2-7-1-released/)
- Rails [6.0.2.2](https://rubygems.org/gems/rails/versions/6.0.2.2)

##### 1. Check out the repository

```bash
git clone git@github.com:JoelAlayon123/Moovie-API.git
```

##### 2. Create database.yml file

Copy the sample database.yml file and edit the database configuration as required.

```bash
cp config/database.yml.sample config/database.yml
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
