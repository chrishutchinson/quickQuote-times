#!/bin/bash
echo "removing existen heroku remote"
git remote rm heroku

#heroku apps:destroy --app $app --confirm $app

sh ./first_time_deploy.sh
