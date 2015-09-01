#!/bin/bash
echo "Launching Heroku first time deployment script"


#echo "give a name to your app(no spaces):"

#read appName
#heroku login

#comment out after the first time of deployment, unless you want to create a new instance
#echo "add this URL to Google Console Redirect URIs: http://${appName}.herokuapp.com/auth/google_oauth2/callback"


#echo "running heroku create ${appName}"
#heroku create $appName

echo "running heroku create getquickquote"
heroku create  --buildpack https://github.com/ddollar/heroku-buildpack-multi
# or use line below with a name you'd like to give to your application, fyi getquickquote is already taken
#heroku create getquickquote --buildpack https://github.com/pietrop/heroku-buildpack-multi

echo "running deployment script"
sh ./deploy.sh