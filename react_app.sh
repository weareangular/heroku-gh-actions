#!bin/bash
#
#===================================
#=========DEPLOYREACTERAPP==========
#===================================
herokureactconfig(){
    echo $(cat package.json | jq '.type = "module"') > ./package.json
    echo "${reactservejs}" > ./serve.js
    echo "${reactenv}" > ./src/.env
    echo "${reactprocfile}" > ./Procfile
}
#===================================
deployreactapp(){
    herokugitcredentials "${1}"
    herokugitconfig "${1}"
    herokuaddremote "${1}"
    herokureactconfig
    herokucleanrepo "${1}"
    herokucommitandpush
    herokusuccess "${1}"
}
#===================================
#==============String===============
#===================================
reactservejs=$(cat << EOF
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
reactenv=$(cat << OEF
#.env

GENERATE_SOURCEMAP=false
OEF
)
#===================================
reactprocfile=$(cat << OEF
//Procfile
web: node ./serve.js
OEF
)
