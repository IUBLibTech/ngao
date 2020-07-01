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

## Delayed Job
The indexing for this application is performed as a background process using Delayed Jobs. https://github.com/collectiveidea/delayed_job

Make sure to run `rake jobs:work` to start the background processing.
More information about running the jobs in production can be found here: https://github.com/collectiveidea/delayed_job#running-jobs

## Cron Job
There is a cron job that is scheduled to run every 24 hours which runs the indexer. This is managed with the Whenever gem. You will need to run this command in a deploy script or on the server to start the job.

`bundle exec whenever --update-crontab` 

Information on the Whenever gem can be found at [https://github.com/javan/whenever](https://github.com/javan/whenever)

## Customizing the devise views

This uses the [Devise Bootstrap Views](https://github.com/hisea/devise-bootstrap-views) gem to style the user authentication pages.

The gem supports i18n localizations, though it is not enabled by default. To add it to the app, use [devise-i18n](https://github.com/tigrish/devise-i18n)

This app uses the default views in the bootstrap-views gem, if you wish to customize them further, run `rails generate devise:views:bootstrap_templates` to create a local copy to modify.

## Add custom content to Home and Repositories page
To add home page content:
1. add html content at 'app/catalog/_home.html.erb

To add Repositories page content:
1. add html content to 'app/views/arclight/repositories/index.html.erb'

## Adding new static pages:
To add new static pages:
1. add a method to app/controllers/pages_controller.rb
  def new_page
  end
2. create a new file in app/views/pages:
  new_page.html.erb
3. add new path to config/routes.rb
  get '/new_page', to: 'pages#new_page', as: 'new_page'
4. add link to 'app/views/shared/_static_pages_links'
  <li class="nav-item ml-3"> <% link_to 'new_page', new_page_path, class: 'nav-link' %></li>
5. add page header title to config/locales/arclight.en.yml under views:
  new_page: title: new_page title
