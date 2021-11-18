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
            && { env_name=$(echo "${arg_name}"); env_value=$(echo "${line#*=}"); } \
            || { env_name=$(echo "${arg_name}" | sed 's/Encoded_//'); env_value=$(echo -e "${line#*=}" | base64 -d); }
        [[ $( heroku config:get ${env_name} --app="${1}") != "${env_value}" ]] \
            && { heroku config:set "${env_name}"="${env_value}" --app="${1}" 1>/dev/null; } \
            || { echo "Variable setting ${env_name} skipped."; }
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
herokucleanrepo(){
    heroku plugins:install heroku-repo
    heroku repo:reset -a ${1}
}
#===================================
herokusuccess(){
    echo "Successful deploy on:"
    echo "https://${1}.herokuapp.com/"
}
