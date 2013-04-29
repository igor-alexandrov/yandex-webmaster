[![Dependency Status](https://gemnasium.com/igor-alexandrov/webmaster.png)](http://gemnasium.com/igor-alexandrov/webmaster)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/igor-alexandrov/webmaster)

# webmaster

Wrapper for Yandex.Webmaster API. 

**About Yandex.Webmaster**

* [Russian](http://webmaster.yandex.ru/)
* [English](http://webmaster.yandex.com/)

**API Documentation**

* [Russian](http://api.yandex.ru/webmaster/)
* [English](http://api.yandex.com/webmaster/)

## Installation

    [sudo] gem install webmaster

## Usage

### Authentication

Yandex's API uses OAuth for authentication. Luckily, the Webmaster gem hides most of the details from you.

If you have never used Webmaster API or you want to change your authentication credentials or your authorization token expired, then you should create new one:

```ruby    
require 'rubygems'
require 'webmaster'

# Get your API credentials at https://oauth.yandex.ru/
client = Webmaster.new(:app_id => 'your_app_id', :app_password => 'your_app_password')
  => #<Webmaster::Client>

# Follow the authorization url, you will be redirected to the callback url, specified in your application settings.
client.authorize_url
  => "https://oauth.yandex.ru/authorize?response_type=code&client_id=your_app_id"

# Use authorization code from params to get authorization token
client.authenticate(params[:code])
  => #<Webmaster::Client>

# If no error is raised then you are free to use any API method
# Too see what token is now used call for client configuration
token = client.configuration.oauth_token	
  => "82af4af2a42e4019bd59a325da0f31d8"
```

If you want to restore previously used token, it can be easily done too:

```ruby
require 'rubygems'
require 'webmaster'

# get your API credentials at https://oauth.yandex.ru/
client = Webmaster.new(:oauth_token => 'token')
```    

To check whether you client is authenticated or not, use `authenticated?` method.

```ruby
# We have already initialized client before.
client.authenticated?
  => true
```    


## Note on Patches / Pull Requests

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but
   bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Credits

![JetRockets](http://www.jetrockets.ru/public/logo.png)

Webmaster is maintained by [JetRockets](http://www.jetrockets.ru/en).

Contributors:

* [Igor Alexandrov](http://igor-alexandrov.github.com/)

## License

It is free software, and may be redistributed under the terms specified in the LICENSE file.
