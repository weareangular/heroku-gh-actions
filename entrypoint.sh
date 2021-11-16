#!bin/bash
#
#===================================
set -e
#===================================
#===================================
#===================================
__dir_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__dir_root=${__dir_script%/*}
#===================================
#=============SCRIPTS===============
#===================================
source ${__dir_script}/container_app.sh
source ${__dir_script}/react_app.sh
source ${__dir_script}/utils.sh
#===================================
#==============HELP=================
#===================================
help() {
  cat << EOF
usage: $0 [OPTIONS]
    --h                                             Show this message 
    --deploy-container-app [APP_NAME]               deploy container app on heroku
                                                    [APP_NAME] => app name *required
    [ARGS...]                                       arguments you want to use for the heroku cli
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
#==========PARAMSANDARGS============
#===================================
while (( "$#" )); do
    case ${1} in
        --h)
            help
            exit 0
        ;;
        --deploy-container-app)
            init
            checkappname "${2}"
            herokucreateapp "${2}"
            herokuargs "${2}"
            deploycontainerapp "${2}"
            exit 0
        ;;
        --deploy-react-app)
            init
            checkappname "${2}"
            herokucreateapp "${2}"
            herokuargs "${2}"
            deployreactapp "${2}"
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
