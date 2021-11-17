# GitHub Actions for Heroku

This Action for [heroku](www.heroku.com) enables arbitrary actions with the `heroku` command-line client.

<div align="center">
<img src="https://github.githubassets.com/images/modules/site/features/actions-icon-actions.svg" height="80"></img>
&nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
&nbsp;&nbsp;
<img src="https://www3.assets.heroku.com/assets/logo-purple-08fb38cebb99e3aac5202df018eb337c5be74d5214768c90a8198c97420e4201.svg" height="80"></img>
</div>

## Inputs

- `--deploy-container-app [APP_NAME]` - deploy container app on heroku.
  - `[APP_NAME]` - is the name of the app where it should be deployed.
- `--deploy-react-app [APP_NAME]` - deploy react app on heroku.
  - `[APP_NAME]` - is the name of the app where it should be deployed.
- `args` - **Required**. This is the arguments you want to use for the `heroku` cli.

## Environment variables

- `HEROKU_API_KEY` - **Required**. The token to use for authentication.
- `HEROKU_BRANCH_NAME` - Name of the branch where the deployment will take place. By default 'main'.
- `App_Env_NAME` - The script will take all environment variables with this pattern and assign them to the application, it will remove 'App_Env' from the variable name.
  - Example:
    - Environment variable in GitHub Workflows:
      > App_Env_Credentials=Something
    - Variable in environment in Heroku:
      > Credentials=Something
- `App_Env_Encoded_Name` - The script will take all the environment variables with this pattern and assign them to the application, remove 'App_Env_Encoded' from the variable name and base64 decode the content.
  - Example:
    - Environment variable in GitHub Workflows:
      > App_Env_Encoded_Credentials=dGhpcyBpcyBhIGVuY29kZWQgdGVzdAo=
    - Variable in environment in Heroku:
      > Credentials=this is a encoded test

## Example

To authenticate with Heroku, and deploy Docker Container:

```yaml
name: Build Docker container and deploy in Heroku
on:
  push:
    branches:
      - master

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: weareangular/heroku-gh-actions@master
        with:
          args: --deploy-container-app ${{ secrets.APP_NAME }}
        env:
          HEROKU_API_KEY: ${{ secrets.HEROKU_TOKEN_DEV }}
          HEROKU_BRANCH_NAME: ${{ secrets.HEROKU_BRANCH_NAME }}
          App_Env_Arg1: ${{ secrets.ARG1 }}
          App_Env_Encoded_Arg2: ${{ secrets.ARG1 }}
```

To authenticate with Heroku, and deploy React App:

```yaml
name: Build React app and deploy in Heroku
on:
  push:
    branches:
      - master

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: weareangular/heroku-gh-actions@master
        with:
          args: --deploy-react-app ${{ secrets.APP_NAME }}
        env:
          HEROKU_API_KEY: ${{ secrets.HEROKU_TOKEN_DEV }}
```
