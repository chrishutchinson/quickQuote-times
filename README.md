# Welcome To quickQuote Documentation!
This site covers quickQuote’s documentation. For basic info on what quickQuote is, as well as a live demo, and user manual please see the main project website - [times.github.io/quickQuote ](http://times.github.io/quickQuote)
.

# System Manual
Here is a step by step plan on how to install quickQuote. It will get you to a point of having a deployed instance on Heroku.


## Prerequisite

You will need to have the following installed
  - ruby
  - ruby on rails
  - Git
    - Git installed locally
    - Github
  - Heroku
    - Heroku account
    - Heroku installed locally
  - ffmpeg (for running development version locally)
  - MySql
  	- MySql
  	- Sequel Pro


Showing how to install these is behiond the scope of this system manual.

<!--  but if you follow the links, they will take you to the project wiki where there are more detailed resources on each-->


<!-- Vagrant virtual machine with al specific versions, script with configuration -->

## System dependencies

a list of most relevant system dependencies

- ruby version 2.0.0
- rails version 4.2.0
- ffmpeg version 2.7.1
	- --enable-shared
	- --enable-pthreads
	- --enable-gpl
	- --enable-version3
	- --enable-hardcoded-tables
	- --enable-avresample
	- --cc=clang
	- --host-cflags=
	- --host-ldflags=
	- --enable-libx264
	- --enable-libmp3lame
	- --enable-libvo-aacenc
	- --enable-libxvid
	- --enable-libvorbis
	- --enable-libvpx
	- --enable-vda
- Video js 4.12.8 *cdn*
- jquery 3.0.0-alpha1 *cdn*
- bootswatch paper bootstrap.min.css 3.3.5 *cdn*
- ajax jquery 1.11.2 *cdn*
- bootstrap js 3.3.5 *cdn*


see `Gemfile` for list of rails gem dependencies.

## Configuration
### API keys

You'll need to make the following accounts to get the API keys

- amazon S3
	- production
	- development
- spoken data API
	- production
	- development
- Google API
	- production
	- development
- local mysql database for testing - *optional*

If not using Heroku, but deploying Heroku style, for instance on Deis, you'll also need a separate database. *optional*
 - amazon RDS
	- production
	- development


#### spoken data
Getting two API keys for spoken data requires two email address to make two distinct account(or 3 if you want only for testing), if you prefer you can just use one account for production and development, but I'd advise against as it can get messy quickly if you try to distinguish on their dashboard which videos you uploaded in development and which once are your users.

#### Google API key
In the Google developer console, create a new project, and get the client id and client secret.

and **enable Google+**.

You'll also Also setup a call back URI, such as

```
http://name_of_your_application.herokuapp.com/auth/google_oauth2/callback
```
You'll need a URI for the deployed application and one for development. 
Google does not support adding localhost, so you'll need to setup a custom local url.
explained below


##### Local domain name for use in development
For use during developemeant it requires to setup a local DNS for your local  host address that maps to your localhost.

In terminal

```bash
$ sudo nano /etc/hosts
```
in the `hosts` file
```
127.0.0.1	localhost	**your  local domain name**.com
```
You can use same details for development and testing.
This needs to be added to the Google Console API as the redirect URL.
so that  in `config/application.yml` you can set the environment variable to be:

```html
REDIRECT_URIS: 'http://**your local domain name**.com:3000/auth/google_oauth2/callback'
```

**testing** _optional_ you might want to get a dummy gmail address without step two authentication to use for selenium testing.
you can use one of the once used in .


### add API Keys to project

we are using the [figaro gem][figaro] to deploy our environment variables onto Heroku.
add API keys to a file `config/application.yml`

dividing by production and development.

<!-- In the project folder there's a file called `config/loval_env.yml.md` you can change the extension back to `yml` by removing `.md` from the file name, and use it as a template to add your API keys to the project-->

<!--  or use figaro and add them to `config/application.yml`  -->

```
$ bundle exec figaro install
```

adds to  `config/application.yml`  and adds it to `.gitingore`.

```
# Ignore application configuration
/config/application.yml
```

However, what you want to do is to remove the `/` like so

```
# Ignore application configuration
config/application.yml
```
Otherside you might accidentally deploy your enviroment variables.

<!-- uses the Figaro gem https://github.com/laserlemon/figaro  -->
you can use the following template to fill in the details in `config/application.yml`


```ruby
GOGLE_PROJECT_ID: ''

test:
  #Google Project ID, OAuth 2.0 client ID:
  GOOGLE_CLIENT_ID_DEVELOPMENT: ''
  GOOGLE_CLIENT_SECRET_DEVELOPMENT: ''
  REDIRECT_URIS: 'http://your_local_domain.com:3000/auth/google_oauth2/callback'
  JAVASCRIPT_ORIGINS:  'https://www.example.com'
  #MysQL db - Local
  DB_TEST_USERNAME: 'root'
  DB_TEST_PASSWORD: ''
  DB_TEST_DB: ''
  DB_TEST_END_POINT: '127.0.0.1'
  DB_TEST_PORT: '3306'
  #S3 Bucket
  AMAZON_S3_ACCESS_KEY_ID: ''
  AMAZON_S3_SECRET_ACCESS_KEY: ''
  AMAZON_S3_BUCKET: ''
  #Spoken Data API
  SPOKEN_DATA_USER_ID: ''
  SPOKEN_DATA_API_TOKEN: ''

development:
  #Google Project ID, OAuth 2.0 client ID:
  GOOGLE_CLIENT_ID_DEVELOPMENT: ''
  GOOGLE_CLIENT_SECRET_DEVELOPMENT: ''
  REDIRECT_URIS: 'http://your_local_domain.com:3000/auth/google_oauth2/callback'
  JAVASCRIPT_ORIGINS:  'https://www.example.com'
  #MysQL db - Amazon RDS
  RDS_USERNAME_DEVELOPMENT: ''
  RDS_PASSWORD_DEVELOPMENT: ''
  RDS_DB_DEVELOPMENT: ''
  RDS_END_POINT_DEVELOPMENT: ''
  RDS_PORT_DEVELOPMENT: ''
  #S3 Bucket
  AMAZON_S3_ACCESS_KEY_ID: ''
  AMAZON_S3_SECRET_ACCESS_KEY: ''
  AMAZON_S3_BUCKET: ''
  #Spoken Data API
  SPOKEN_DATA_USER_ID: ''
  SPOKEN_DATA_API_TOKEN: ''

production:
  #Google Project ID, OAuth 2.0 client ID:
  GOOGLE_CLIENT_ID: ''
  GOOGLE_CLIENT_SECRET: ''
  REDIRECT_URIS: 'http://the_name_of_your_app.herokuapp.com/auth/google_oauth2/callback'
  JAVASCRIPT_ORIGINS:  ''
  #MysQL db - Amazon RDS
  RDS_USERNAME: ''
  RDS_PASSWORD: ''
  RDS_DB: ''
  RDS_END_POINT: ''
  RDS_PORT: ''
  #S3 Bucket
  AMAZON_S3_ACCESS_KEY_ID: ''
  AMAZON_S3_SECRET_ACCESS_KEY: ''
  AMAZON_S3_BUCKET: ''
  #Spoken Data API
  SPOKEN_DATA_USER_ID: ''
  SPOKEN_DATA_API_TOKEN: ''
```

## How to run the test suite
There is a selenium script to programmatically test login and file upload.

To run it from root of the application use the following comand

```bash
$ ruby /test/selenium/selenium_test_video_upload.rb
```

## Database creation -  for local developement and testing.
This can be used for testing as well.

- [Install mysql locally *os x* ](https://dev.mysql.com/doc/refman/5.6/en/osx-installation-pkg.html)
- To start the server *System preferences > MySQL > Start MySQL Server*
- Use [Squel Pro](http://www.sequelpro.com/) (or equivalent) to connect to the local MySQL db server.

```  
  #MysQL db - Local
  DB_TEST_USERNAME: 'root'
  DB_TEST_PASSWORD: ''
  DB_TEST_DB: ''
  DB_TEST_END_POINT: '127.0.0.1'
  DB_TEST_PORT: '3306'
```

For production, the database is created as part of the deployment script.

## Deployment instructions

To [deploy onto heroku][heroku_deployment] cd into the application root folder, login into heroku.

```
$ heroku login
```

Then run one of the deployment scripts.
Before running the script, inspect the script to costumise the deployment to your needs, and make sure it does what expected, I take no responsability for these 3 deployment script.

When deploying the application for the first time run.

```bash
$ ./first_time_deploy.sh
```

For subsequent deployments you can use

```bash
$ ./deploy.sh
```

If after the first deployment you want to deploy as new application run

```bash
$ new_deploy.sh
```

Note that this last one, does not delete the previous application, it simply removes the git remote.
if you wish to delete it, you'd need to run `heroku apps:destroy --app $app --confirm $app` where `$app` is the name of the app you want to delete. Alternatively you can log in to you Heroku account and delete it from there.


[heroku_deployment]: https://devcenter.heroku.com/articles/getting-started-with-rails4
[figaro]: https://github.com/laserlemon/figaro
<!-- a rake comand to execute installaiton on heroku -->

<!--
also see [here](https://devcenter.heroku.com/articles/github-integration) if you want to do automatic deploy from github account.
 -->
<!-- mysql remote on heroku http://www.christophseydel.pro/blog/2013/09/26/connect-to-remote-mysql-database-from-heroku-europe/ -->

<!-- Need to change, remote RDS instance to pg gem and use postgress on heroku -->


# Licence


[quickQuote](http://times.github.io/quickQuote) is licensed under the [MIT license](http://opensource.org/licenses/MIT)