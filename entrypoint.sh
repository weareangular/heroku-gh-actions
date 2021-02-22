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
herokucheckapp(){
    [[ -n $( heroku apps | grep ${app} ) ]] && return 0 || return 1
}

#===================================
herokucreateapp(){
    herokucheckapp
    [[ $? -eq 0 ]] || heroku create ${app}
    return 0
}

#===================================
herokuargs(){
    if [[ -n ${env_params} ]]; then
        for arg in "${env_params[@]}"; do
            heroku config:set "${arg}" --app="${app}"
        done
    fi
    return 0
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
herokuopen(){
    heroku open --app="${app}"
}
#===================================
deploycontainerapp(){
    echo "herokucontainerlogin"
    herokucontainerlogin
    echo "herokucreateapp"
    herokucreateapp
    echo "herokuargs"
    herokuargs
    echo "herokupush"
    herokupush
    echo "herokurelease"
    herokurelease
    echo "herokuopen"
    herokuopen
}
#===================================
#==========PARAMSANDARGS============
#===================================
params=()
while (( "$#" )); do
    case ${1} in
        --h)
            help
            exit 0
        ;;
        --deploy-container-app)
            app=${2}
            env_params=()
            for ARGUMENT in "${@:3}"; do
                env_params+=("$(echo $ARGUMENT | cut -f1 -d=)=\"$(echo $ARGUMENT | cut -f2 -d=)\"")
            done
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
