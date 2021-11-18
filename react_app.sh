#!bin/bash
#
#===================================
#========DEPLOYCONTAINERAPP=========
#===================================
herokugitconfig(){
    email="$(heroku access -a ${1} | grep owner)"
    git config --global user.email "${email}"
    git config --global user.name "${email%%@*}"
}
#===================================
herokuaddremote(){
    heroku git:remote -a "${1}"
}
#===================================
herokureactconfig(){
    echo $(cat package.json | jq '.type = "module"') > ./package.json
    echo "${servejs}" > ./serve.js
    echo "${env}" > ./src/.env
    echo "${procfile}" > ./Procfile
}
#===================================
herokureactcommitandpush(){
    git add .
    git commit -m "deploy to heroku"
    git fetch --all --unshallow
    git push heroku HEAD:${HEROKU_BRANCH_NAME}
}
#===================================
deployreactapp(){
    herokugitcredentials "${1}"
    herokugitconfig "${1}"
    herokuaddremote "${1}"
    herokureactconfig
    herokucleanrepo "${1}"
    herokureactcommitandpush
    herokusuccess "${1}"
}
#===================================
#==============String===============
#===================================
servejs=$(cat << EOF
import express from 'express';
import path from 'path';

const port = process.env.PORT || 8080;
const app = express();
const dirname = '/app'

app.use(express.static(dirname));
app.use(express.static(path.join(dirname, 'build')));

app.get('/_health', function (req, res) {
return res.send('OK');
});
app.get('/*', function (req, res) {
res.sendFile(path.join(dirname, 'build', 'index.html'));
});

app.listen(port);
EOF
)
#===================================
env=$(cat << OEF
#.env

GENERATE_SOURCEMAP=false
OEF
)
#===================================
procfile=$(cat << OEF
//Procfile
web: node ./serve.js
OEF
)
