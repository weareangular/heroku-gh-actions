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

- `--deploy-container-app [APP_NAME] [ARGS...]` - deploy container app on heroku.
  - `[APP_NAME]` - is the name of the app where it should be deployed.
  - `[ARGS...]` - all those environment variables that you want to add to the application to be deployed
- `args` - **Required**. This is the arguments you want to use for the `heroku` cli.

## Environment variables

- `HEROKU_API_KEY` - **Required**. The token to use for authentication.

## Example

To authenticate with Heroku, and deploy Heroku container:

```yaml
name: Build and deploy in Heroku (Development)
on:
  push:
    branches:
      - dev

jobs:
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: weareangular/heroku-gh-actions@master
        with:
          args: --deploy-container-app ${{ secrets.APP_NAME }} ARG1=${{ secrets.ARG1 }} ARG2=${{ secrets.ARG2 }}...
        env:
          HEROKU_API_KEY: ${{ secrets.HEROKU_TOKEN_DEV }}
```
