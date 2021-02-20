#!bin/bash 
#
#===================================
getAPI(){
    [[ -n $(grep API_KEY .env | cut -d '=' -f2) ]] && API_KEY=$(grep API_KEY .env | cut -d '=' -f2) || { echo -e "\nEither API_KEY is required to run test the heroku cli"; exit 162; }
}
#===================================
deleteimageifexist(){
    [[ -n $( docker images | grep wrap-heroku ) ]] && docker rmi wrap-heroku:1.0 
}
#===================================
buildockerdimage(){
    docker build -t wrap-heroku:1.0 . 
}
#===================================
rundockerbash(){
    tput setaf 6
    echo -e "\nTESTING HEROKU CLI WITH 'APPS' COMMAND"
    tput sgr0
    docker run --env HEROKU_API_KEY=${API_KEY} -it --rm wrap-heroku:1.0 apps
}
#===================================
rundockerhelp(){
    docker run -it --rm wrap-heroku:1.0 --h
}
#===================================
run(){
    getAPI
    deleteimageifexist
    buildockerdimage
    rundockerbash
}
#===================================
run
