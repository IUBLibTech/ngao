# Archives Online
Next Generation Archives Online on ArcLight

# Installation and Usage
To setup the server:

```
bundle install
```

Then, to run the server:

```
bundle exec rake demo:server  # runs both Rails and Solr
```

## Indexing sample data
Sample files are included in the data directory. To index sample data:

```
REPOSITORY_ID=paleontology DIR=./data/paleontology rake arclight:index_dir
```


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
