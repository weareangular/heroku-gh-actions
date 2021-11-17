#!bin/bash 
#
#===================================
App_Env_REACT_APP_PHOTO_URL_EMPTY=https://avatars0.githubusercontent.com/t/3799675?s=280&v=4
App_Env_REACT_APP_AURORA_PHONE_NUMBER=3002895394
App_Env_REACT_APP_AURORA_CONTACT_EMAIL=info@somosaurora.co
App_Env_REACT_APP_VERIFY_EMAIL=https://test-herokuwrap-weareangular.herokuapp.com/login/email/verify
App_Env_REACT_APP_CHANGE_EMAIL_PASSWORD=https://test-herokuwrap-weareangular.herokuapp.com/
App_Env_REACT_APP_FIREBASE_API_KEY=AIzaSyAGD8ZIHb7LnAmmg0W3qg1fsRfIuvthm84
App_Env_REACT_APP_FIREBASE_AUTH_DOMAIN=somos-aurora-staging.firebaseapp.com
App_Env_REACT_APP_FIREBASE_DATABASE_URL=https://somos-aurora-staging-default-rtdb.firebaseio.com
App_Env_REACT_APP_FIREBASE_PROJECT_ID=somos-aurora-staging
App_Env_REACT_APP_FIREBASE_STORAGE_BUCKET=somos-aurora-staging.appspot.com
App_Env_REACT_APP_FIREBASE_MESSAGING_SENDER_ID=937619369728
App_Env_REACT_APP_FIREBASE_APP_ID=1:937619369728:web:6990cfba59aba5cdf94de5
App_Env_REACT_APP_FIREBASE_MEASUREMENT_ID=G-EL0F08P3SC
GITHUB_REF_NAME=master
HEROKU_BRANCH_NAME=main
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
    docker build --no-cache -t wrap-heroku:1.0 . 
}
#===================================
rundockerbash(){
    tput setaf 6
    echo -e "\nTESTING HEROKU CLI WITH 'APPS' COMMAND"
    tput sgr0
    docker run -v "/home/gio/test/aurora-learning-core/":"/github/workspace/" --entrypoint /bin/bash --env HEROKU_API_KEY=${API_KEY} \
    --env App_Env_REACT_APP_PHOTO_URL_EMPTY="${App_Env_REACT_APP_PHOTO_URL_EMPTY}" \
    --env App_Env_REACT_APP_AURORA_PHONE_NUMBER="${App_Env_REACT_APP_AURORA_PHONE_NUMBER}" \
    --env App_Env_REACT_APP_AURORA_CONTACT_EMAIL="${App_Env_REACT_APP_AURORA_CONTACT_EMAIL}" \
    --env App_Env_REACT_APP_VERIFY_EMAIL="${App_Env_REACT_APP_VERIFY_EMAIL}" \
    --env App_Env_REACT_APP_CHANGE_EMAIL_PASSWORD="${App_Env_REACT_APP_CHANGE_EMAIL_PASSWORD}" \
    --env App_Env_REACT_APP_FIREBASE_API_KEY="${App_Env_REACT_APP_FIREBASE_API_KEY}" \
    --env App_Env_REACT_APP_FIREBASE_AUTH_DOMAIN="${App_Env_REACT_APP_FIREBASE_AUTH_DOMAIN}" \
    --env App_Env_REACT_APP_FIREBASE_DATABASE_URL="${App_Env_REACT_APP_FIREBASE_DATABASE_URL}" \
    --env App_Env_REACT_APP_FIREBASE_STORAGE_BUCKET="${App_Env_REACT_APP_FIREBASE_STORAGE_BUCKET}" \
    --env App_Env_REACT_APP_FIREBASE_MESSAGING_SENDER_ID="${App_Env_REACT_APP_FIREBASE_MESSAGING_SENDER_ID}" \
    --env App_Env_REACT_APP_FIREBASE_APP_ID="${App_Env_REACT_APP_FIREBASE_APP_ID}" \
    --env App_Env_REACT_APP_FIREBASE_PROJECT_ID="${App_Env_REACT_APP_FIREBASE_PROJECT_ID}" \
    --env App_Env_REACT_APP_FIREBASE_MEASUREMENT_ID="${App_Env_REACT_APP_FIREBASE_MEASUREMENT_ID}" \
    --env GITHUB_REF_NAME="${GITHUB_REF_NAME}" \
    --env HEROKU_BRANCH_NAME="${HEROKU_BRANCH_NAME}" \
    -it --rm wrap-heroku:1.0
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
