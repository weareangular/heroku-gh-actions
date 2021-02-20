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
    docker run -it --rm wrap-heroku:1.0 /bin/bash --env API_KEY=${API_KEY}
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
