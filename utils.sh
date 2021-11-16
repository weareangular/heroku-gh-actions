#!bin/bash
#
#===================================
#===============UTILS===============
#===================================
herokugitcredentials(){
    email="$(heroku access -a ${1} | grep owner)"
    cat > ~/.netrc <<EOF
machine git.heroku.com
  login ${email}
  password ${HEROKU_API_KEY}
EOF
}
#===================================
herokucreateapp(){
    [[ -n $( heroku apps | grep "${1}" ) ]] || heroku create "${1}"
}
#===================================
herokuargs(){
    env | grep App_Env | sed 's/App_Env_//' | while read -r line ; do
        arg_name=$(echo "$line" | cut -f1 -d=)
        [[ ${arg_name%%_*} != "Encoded" ]] \
            && { env_arg=("$(echo "$line" | cut -f1 -d=)=$(echo "${line#*=}")"); } \
            || { env_arg=("$(echo "${arg_name}" | sed 's/Encoded_//')=$(echo -e "${line#*=}" | base64 -d)"); }
        heroku config:set "${env_arg}" --app="${1}" > /dev/null
    done
}
#===================================
checkappname(){  
    if [[ -z $1 ]]; then
        echo -e "Error: Either App_name is required to run the command."
        exit 126
    fi
}
#===================================
herokusuccess(){
    echo "Successful deploy on:"
    echo "https://${1}.herokuapp.com/"
}
