#!/bin/bash
#chmod +x deploy.sh to make script executable
echo "Launching Heroku deployment script"

# if app already been created using this to rename
#heroku apps:rename $appName

echo "set enviroment variables from application.yml"
figaro heroku:set -e production

echo "bundle install"

#bundle exec figaro install

bundle install

#echo "precompiling rails assets"
#TODO: run this and check if name of image assets break(ie background image)
#rake assets:precompile

# git add and commit, optional
echo "git add -A"
git add -A

echo "git commit"
git commit -m"commit before pushing to heroku"

echo "pushing onto github"
git push

echo "git push heroku master"
git push heroku master

echo "migrating PG db on heroku"
heroku run rake db:migrate

echo "heroku ps:scale web=1 worker=1"
# The worker needs to be on 1 for ffmpeg to work.
heroku ps:scale web=1 worker=1


echo "opening deployed website"
heroku open

echo "heroku status to see if there's any issue with the system "
heroku status

herokuAppNameURL=`heroku info -s | grep web_url | cut -d= -f2`

echo "_________________________IMPORTANT_______________________________________________"
echo "add this URL to Google Console Redirect URIs: ${herokuAppNameURL}auth/google_oauth2/callback"

echo "press any key to run heroku logs stream"

read anykey

echo "running live stream of heroku logs"
heroku logs -t
