#!bin/bash
#
#===================================
#=========DEPLOYNEXTERAPP===========
#===================================
herokunextconfig(){
    echo $(cat package.json | jq '.scripts.start = "next start -p $PORT"') > ./package.json
    cat ./package.json
    echo "${nextenv}" > ./src/.env
    echo "${nextprocfile}" > ./Procfile
}
#===================================
deploynextapp(){
    herokugitcredentials "${1}"
    herokugitconfig "${1}"
    herokuaddremote "${1}"
    herokunextconfig
    herokucleanrepo "${1}"
    herokucommitandpush
    herokusuccess "${1}"
}
#===================================
#==============String===============
#===================================
nextenv=$(cat << OEF
#.env

GENERATE_SOURCEMAP=false
OEF
)
#===================================
nextprocfile=$(cat << OEF
//Procfile
web: npm run start
OEF
)
