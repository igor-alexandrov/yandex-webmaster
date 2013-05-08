[![Dependency Status](https://gemnasium.com/igor-alexandrov/webmaster.png)](http://gemnasium.com/igor-alexandrov/yandex-webmaster)
[![Code Climate](https://codeclimate.com/github/igor-alexandrov/yandex-webmaster.png)](https://codeclimate.com/github/igor-alexandrov/yandex-webmaster)

# yandex-webmaster

Wrapper for Yandex.Webmaster API. 

**About Yandex.Webmaster**

* [Russian](http://webmaster.yandex.ru/)
* [English](http://webmaster.yandex.com/)

**API Documentation**

* [Russian](http://api.yandex.ru/webmaster/)
* [English](http://api.yandex.com/webmaster/)

## Installation

    [sudo] gem install yandex-webmaster

## Usage

### Authentication

Yandex's API uses OAuth for authentication. Luckily, the Webmaster gem hides most of the details from you.

If you have never used Webmaster API or you want to change your authentication credentials or your authorization token expired, then you should create new one:

```ruby    
require 'rubygems'
require 'yandex-webmaster'

# Get your API credentials at https://oauth.yandex.ru/
webmaster = Yandex::Webmaster.new(:app_id => 'your_app_id', :app_password => 'your_app_password')
  => #<Yandex::Webmaster::Client>

# Follow the authorization url, you will be redirected to the callback url, specified in your application settings.
webmaster.authorize_url
  => "https://oauth.yandex.ru/authorize?response_type=code&client_id=your_app_id"

# Use authorization code from params to get authorization token
webmaster.authenticate(params[:code])
  => #<Yandex::Webmaster::Client>

# If no error is raised then you are free to use any API method
# Too see what token is now used call for client configuration
token = webmaster.configuration.oauth_token	
  => "82af4af2a42e4019bd59a325da0f31d8"
```

If you want to restore previously used token, it can be easily done too:

```ruby
require 'rubygems'
require 'yandex-webmaster'

# get your API credentials at https://oauth.yandex.ru/
webmaster = Yandex::Webmaster.new(:oauth_token => 'token')
  => #<Yandex::Webmaster::Client>
```    

To check whether you client is authenticated or not, use `authenticated?` method.

```ruby
# We have already initialized client before.
webmaster.authenticated?
  => true
```    

### Operations with the list of sites

**Get list of sites**

```ruby
webmaster.hosts
  => #<Array[Yandex::Webmaster::Host]>
```   

**Create site**
```ruby
webmaster.create_host('hostname')
  => #<Yandex::Webmaster::Host>
```   

### Operations with a site

**Getting site resources**

You can easily find out what API methods are available for selected host.

```ruby
h = webmaster.hosts.last
  => #<Yandex::Webmaster::Host>
  
h.resources
  => {:host_information => "https://webmaster.yandex.ru/api/v2/hosts/<host_id>/stats", :verify_host => "https://webmaster.yandex.ru/api/v2/hosts/<host_id>/verify" ... :excluded_urls_history => "https://webmaster.yandex.ru/api/v2/hosts/<host_id>/history/excluded-urls"}	  
```   
 
**Deleting a site**

```ruby
h = webmaster.hosts.last
  => #<Yandex::Webmaster::Host>
  
h.delete
  => #<Yandex::Webmaster::Host>

h.deleted?
  => true  	
```

### Operations with site statistics

Request refreshes following fields in Host:
 * `#name`
 * `#verification`
 * `#crawling`
 * `#virused`
 * `#last_access`
 * `#tic`
 * `#url_count`
 * `#index_count`
 
Also request populates the following fields:
 * `#url_errors`
 * `#internal_links_count`
 * `#links_count`

```ruby
h = webmaster.hosts.last
  => #<Yandex::Webmaster::Host>

# Populates host instance with statistics information
h.stats
  => #<Yandex::Webmaster::Host>

h.url_errors
  => 379843
h.internal_links_count
  => 52367    
h.links_count
  => 943

 ```

### Operations with site verification

Basic verification information is loaded with Host load.

For verified sites:

```ruby
h = webmaster.hosts.last
  => #<Yandex::Webmaster::Host>
h.verification
  #<Yandex::Webmaster::Hosts::Verification state: "verified">	
```  

And for not verified sites:

```ruby
h = webmaster.create_host('http://www.tver.ru')
h.verification
 => #<Yandex::Webmaster::Hosts::Verification state: "never_verified">
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
