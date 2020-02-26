# starter-snake-ruby

A simple [Battlesnake AI](http://battlesnake.io) written in Ruby.

Visit [https://github.com/battlesnakeio/community/blob/master/starter-snakes.md](https://github.com/battlesnakeio/community/blob/master/starter-snakes.md) for API documentation and instructions for running your AI.

This AI client uses the Sinatra web framework for running your snake server.

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

#### You will need...

* A working ruby development environment ([installing ruby](https://www.ruby-lang.org/en/documentation/installation/))
* experience [deploying Ruby apps to Heroku](https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction)
* [bundler](https://bundler.io/#getting-started) to install Ruby dependencies

## Running the Snake Locally

1) [Fork this repo](https://github.com/battlesnakeio/battlesnake-2-ruby/fork).

2) Clone repo to your development environment:
```
git clone git@github.com:<your github username>/battlesnake-2-ruby.git
```

3) Install dependencies using [bundler](https://bundler.io/#getting-started):
```
bundle install
```

4) Run local server:
```
ruby app/app.rb
```

5) Test your snake by sending a curl to the running snake
```
curl -XPOST -H 'Content-Type: application/json' -d '{ "hello": "world"}' http://localhost:4567/start
```

## Deploying to Heroku

1) Create a new Heroku app:
```
heroku create [APP_NAME]
```

2) Deploy code to Heroku servers:
```
git push heroku master
```

3) Open Heroku app in browser:
```
heroku open
```
or visit [http://APP_NAME.herokuapp.com](http://APP_NAME.herokuapp.com).

4) View server logs with the `heroku logs` command:
```
heroku logs --tail
```

## Questions?

Email [hello@battlesnake.com](mailto:hello@battlesnake.com), or tweet [@battlesnakeio](http://twitter.com/battlesnakeio).
