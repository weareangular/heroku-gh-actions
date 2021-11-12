#!bin/bash
#
#===================================
#========DEPLOYCONTAINERAPP=========
#===================================
herokucontainerlogin(){
    heroku container:login
}
#===================================
herokupush(){
    heroku container:push web --app="${1}"
}
#===================================
herokurelease(){
    heroku container:release web --app="${1}"
}
#===================================
herokusuccess(){
    echo "Successful deploy on:"
    echo "https://${1}.herokuapp.com/"
}
#===================================
deploycontainerapp(){
    herokucontainerlogin
    herokupush "${1}"
    herokurelease "${1}"
    herokusuccess "${1}"
}
