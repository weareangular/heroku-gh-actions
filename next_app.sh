#!bin/bash
#
#===================================
#==========DEPLOYNEXTAPP============
#===================================
nextenvconfig(){
    env | grep App_Env | sed 's/App_Env_//' | while read -r line ; do
        arg_name=$(echo "$line" | cut -f1 -d=)
        [[ ${arg_name%%_*} != "Encoded" ]] \
            && { env_var=($(echo "${arg_name}")=$(echo "${line#*=}")); } \
            || { env_var=($(echo "${arg_name}" | sed 's/Encoded_//')=$(echo -e "${line#*=}" | base64 -d)); }
        [[ -e ./.env ]] \
            && { echo "${env_var}" >> ./.env; } \
            || { echo "${env_var}" > ./.env; }
    done
}
#===================================
herokunextconfig(){
    echo $(cat package.json | jq '.scripts.start = "next start -p $PORT"') > ./package.json
    echo "${nextprocfile}" > ./Procfile
    nextenvconfig
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
