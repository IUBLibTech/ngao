# Docker development setup

1) Install Docker.app 

2) gem install stack_car

3) We recommend committing .env to your repo with good defaults. .env.development, .env.production etc can be used for local overrides and should not be in the repo.

4) sc up

``` bash
gem install stack_car
sc up

```

# Deploy a new release

``` bash
sc release {staging | production} # creates and pushes the correct tags
sc deploy {staging | production} # deployes those tags to the server
```

Releaese and Deployment are handled by the gitlab ci by default. See ops/deploy-app to deploy from locally, but note all Rancher install pull the currently tagged registry image
# ngao
Next Generation Archives Online

To setup the server:

```
bundle install
```

Then, to run the server:

```
bundle exec rake demo:server  # runs both Rails and Solr
bundle exec rake demo:seed    # to load data from data/ead folder
```

## Indexing sample data
Sample files are included in the data directory. To index sample data:

Mix repository:
```
FILE=./data/mix/ohrc116.xml REPOSITORY_ID=mix bundle exec rake arclight:index

FILE=./data/mix/VAC0754.xml REPOSITORY_ID=mix bundle exec rake arclight:index

FILE=./data/mix/VAE1573.xml REPOSITORY_ID=mix bundle exec rake arclight:index
```

Lilly repository:
```
FILE=./data/lilly/VAD6017.xml REPOSITORY_ID=lilly bundle exec rake arclight:index

FILE=./data/lilly/VAD6744.xml REPOSITORY_ID=lilly bundle exec rake arclight:index

FILE=./data/lilly/VAD7049.xml REPOSITORY_ID=lilly bundle exec rake arclight:index
```

Archives repository:
```
FILE=./data/archives/VAA2626.xml REPOSITORY_ID=archives bundle exec rake arclight:index

FILE=./data/archives/VAD4127.xml REPOSITORY_ID=archives bundle exec rake arclight:index

FILE=./data/archives/VAD7636.xml REPOSITORY_ID=archives bundle exec rake arclight:index
```

## Updating Arclight

To update to a new version of Arclight:

```
bundle update arclight
```

**NOTE** that if the solr configuration or the fixture data changes, you will need to copy those over manually. Same with the arclight generators (e.g., catalog_controller.rb), you will need to run the `arclight:install` again.

## Updating the application

See https://github.com/sul-dlss/arclight/wiki/Upgrading-your-ArcLight-application
