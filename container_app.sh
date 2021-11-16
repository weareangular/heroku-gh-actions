#!bin/bash
#
#===================================
#========DEPLOYCONTAINERAPP=========
#===================================
herokucontainerlogin(){
    heroku container:login
}
#===================================
herokucontainerpush(){
    heroku container:push web --app="${1}"
}
#===================================
herokucontainerrelease(){
    heroku container:release web --app="${1}"
}
#===================================
deploycontainerapp(){
    herokucontainerlogin
    herokucontainerpush "${1}"
    herokucontainerrelease "${1}"
    herokusuccess "${1}"
}
