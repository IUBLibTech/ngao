# Archives Online
Archives Online is a Blacklight-based application using the [ArcLight Rails engine](https://github.com/projectblacklight/arclight).

## Requirements
- Ruby 2.7+
- Solr 8.x
  - The `solr_wrapper` gem is provided for local development, and is pinned at 8.8.2

## Environment Variables
Wherever possible, configuration details have been handled in a way that allows for 
overrides via environment variables.

A sample environment file has been added to the repository that should work
for developer environments. It, or an alternative file, can be sourced before starting
services like:
```
source bin/setenv.dev
```
**NOTE:** There are two important variables to be aware of. One controls whether the application
should authenticate via IU CAS, and the other sets the location of a custom export site for
EAD XML derivatives. Both require being on the IU network, so non-IU developers
need to set them to avoid resource dependencies. The sample environment file noted
above sets these two variables appropriate to any developer, and they are covered in detail further below.

## Running in the development environment
### Run as a local Rails application
#### After cloning this repository:
```
cd ./ngao
bundle install
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rake assets:precompile
bundle exec rails g archives_online:mock_aspace
```

##### Set environment variables and start services:
```
source ./bin/setenv.dev
bundle exec rake demo:server  # runs both Rails and Solr
```
#### Delayed Job
The indexing for this application is performed as background processes using
[Delayed Jobs.](https://github.com/collectiveidea/delayed_job)
The jobs are also dependent upon the correct environment, so set variables to suite
or source the provided environment file first:
```
source ./bin/setenv.dev
./bin/delayed_job start
```
That will run job processors in the background.  If you want to run them in
a console for observation, use:
```
bundle exec rake jobs:work
```

### Run as an image
Docker images are built and pushed automatically via GitHub Actions on certain
events, like merging to main. Available images are available at
https://hub.docker.com/repository/docker/iublibtech/archives_online. 

Resulting images are used to deploy into our server container environment, and should also 
run in local environments with something like:

```
docker pull iublibtech/archives_online:master

export SERVICE_ROOT=.
export SERVICE_NAME=ngao_devel

docker run \
      --name $SERVICE_NAME \
      --network host \
      --publish 127.0.0.0:3000:3000/tcp \
      --detach \
      --env-file $SERVICE_ROOT/bin/setenv_docker.dev \
      iublibtech/archives_online:master \
      /bin/bash -c "./bin/delayed_job start ; puma -b tcp://0.0.0.0:3000"


docker exec  ngao_devel /bin/bash -c  "bundle exec rake db:migrate"
docker exec  ngao_devel /bin/bash -c  "bundle exec rake db:seed"
docker exec  ngao_devel /bin/bash -c  "bundle exec rails g archives_online:mock_aspace"
```

### Notes on authentication for the Admin Panel
In the IU environment, the default method of authentication is via IU CAS.
This introduces two potential problems for a development environment:
- It requires either a real or guest account at IU.
- A developer's instance has to be running on localhost as SSL for the
  callback from the IU IDP (also, a server deployment must be registered with the
  IDP, which isn't an option for a non-IU environment.)  

Those issues can be eliminated by setting an environment variable that enables
Devise database authentication:
```
export AL_AUTHN=database
```
The Devise self-signup feature is **not** enabled, so this requires creating an admin user:
```
bundle exec rake db:seed
```
That will create the user/password, `testuser@example.com/testing123`. More users can be
created by looking at `db/seeds.rb` as an example. 

### Notes on interactions with IU's ArchiveSpace export site
In the IU environment, the Admin Panel and import jobs are tightly coupled to custom
export sites to get derivative EAD XML for import and indexing.
Those export sites are not accessible outside of the IU network, so this is a problem for
non-IU developers.

To get around this problem, the export site can be mocked up using a generator, and
then the Rails application can be configured to use it with an environment variable:
```
rails g archives_online:mock_aspace
export ASPACE_EXPORT_URL=http://localhost:3000/as_export/
```

Integration tests take care of this automatically by mocking up the export site
using the WebMock gem.



## Indexing and managing sample data
There are a number of Rake tasks that handle import and indexing. Some of these are meant
to be run in a console and invoke Traject directly, while others call services and/or jobs.
Those are capable of runnnig in a console, be triggered from cron jobs, or be invoked from
UI actions on the Admin Panel. 

```
rake arclight:destroy_index_docs  # Destroy all documents in the index
rake arclight:index               # Index an EAD document, use FILE=<path/to/ead.xml> and REPOSITORY_ID=<myid>
rake arclight:index_dir           # Index a directory of EADs, use DIR=<path/to/directory> and REPOSITORY_ID=<myid>
rake arclight:index_url           # Index an EAD document, use URL=<http[s]://domain/path/to/ead.xml> and REPOSITORY_ID=<myid>
rake arclight:index_url_batch     # Index EADs from a file of URLs, use BATCH=<path/to/urls.txt> and REPOSITORY_ID=<myid>
rake clear_eads_history           # Clear database entries for EADs to clear indexing history
rake import_eads                  # Import and Index EADs
rake import_updated_eads          # Import and Index EADs
rake purge_and_index_docs         # Clear EAD indexing history, destroy Solr docs, import all from AS
```

For example, this will work in real time and can be useful to troubleshoot issues with specific documents:
```
REPOSITORY_ID=paleontology DIR=./data/paleontology rake arclight:index_dir
```
Open a browser and verify the application and indexed EAD files at http://localhost:3000/collections

## Build suggest field
Building the suggest list for searching, typeahead, is not done on indexing.  Building the suggest list is done with either the rake task or curl command below.  This should be run after indexing sample data.  Note: update solr url if not running the curl command in local development.

```
rake build_solr_suggest

curl http://127.0.0.1:8983/solr/blacklight-core/suggest\?suggest.build\=true
```

## Running tests

To run tests use:
```
bundle exec rspec
```

There are a few very slow tests that involve the OmniAuth controller.  These have been excluded by default.  To run these tests specifically use:
```
bundle exec rspec --tag omni spec/
```
Edit `./.rspec` to change which tests are excluded by default.

## Updating ArcLight in the application

See https://github.com/sul-dlss/arclight/wiki/Upgrading-your-ArcLight-application



## Customizations
### Disclaimer
*This section on customizatons was provided during previous contractor development
and needs to be reviewed, tested, and edited for accuracy.*
### Customizing views

This uses the [Devise Bootstrap Views](https://github.com/hisea/devise-bootstrap-views) gem to style the user authentication pages.

The gem supports i18n localizations, though it is not enabled by default. To add it to the app, use [devise-i18n](https://github.com/tigrish/devise-i18n)

This app uses the default views in the bootstrap-views gem, if you wish to customize them further, run `rails generate devise:views:bootstrap_templates` to create a local copy to modify.


### Add custom content to Home and Repositories page
To add home page content:
1. add html content at 'app/catalog/_home.html.erb

To add Repositories page content:
1. add html content to 'app/views/arclight/repositories/index.html.erb'

### Adding new static pages:
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
