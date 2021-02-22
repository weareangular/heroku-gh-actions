#!bin/bash
#
#===================================
set -e
#===================================
#==============HELP=================
#===================================
help() {
  cat << EOF
usage: $0 [OPTIONS]
    --h                                     Show this message 
    --deploy-container-app [APP] [ARGS...]  deploy container app on heroku
                                                [APP] => app name
                                                [ARGS...] => arg_name1=arg_value1 arg_name2=arg_value2....
    [ARGS...]                               arguments you want to use for the heroku cli
EOF
}
#===================================
#==============INIT=================
#===================================
checkenvvariables(){  
    if [[ -z $HEROKU_API_KEY ]]; then
        echo -e "\nEither HEROKU_API_KEY is required to run commands with the heroku cli"
        exit 126
    fi
}
#===================================
showinit(){
    echo -e "\nStarting Heroku-Cli\n"
}
#===================================
init(){
    showinit
    checkenvvariables
}
#===================================
#===========RUNHEROKUCLI============
#===================================
runherokucli(){
    bash -c "heroku $*"
}
#===================================
#========DEPLOYCONTAINERAPP=========
#===================================
herokucreateapp(){
    [[ -n $( heroku apps | grep ${app} ) ]] || heroku create ${app}
}

#===================================
herokuargs(){
    if [[ -n ${env_params} ]]; then
        for arg in "${env_params[@]}"; do
            heroku config:set "${arg}" --app="${app}"
        done
    fi
}
#===================================
herokucontainerlogin(){
    heroku container:login
}
#===================================
herokupush(){
    heroku container:push web --app="${app}"
}

#===================================
herokurelease(){
    heroku container:release web --app="${app}"
}
#===================================
herokusuccess(){
    echo "Successful deploy!"
}
#===================================
deploycontainerapp(){
    herokucontainerlogin
    herokucreateapp
    herokuargs
    herokupush
    herokurelease
    herokusuccess
}
#===================================
#==========PARAMSANDARGS============
#===================================
while (( "$#" )); do
    case ${1} in
        --h)
            help
            exit 0
        ;;
        --deploy-container-app)
            app=${2}
            env_params=()
            echo "${@:3}"
            for ARGUMENT in "${@:3}"; do
                env_params+=("$(echo $ARGUMENT | cut -f1 -d=)=\"$(echo $ARGUMENT | cut -f2 -d=)\"")
            done
            echo "${app}"
            echo "${env_params}"
            init
            deploycontainerapp
            exit 0
        ;;
        *)
            init
            runherokucli $*
            exit 0
        ;;
    esac
    shift
done
