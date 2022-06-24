# frozen_string_literal: true

desc 'Create repos from repositories.yml (does NOT remove anything).'
task sync_repos: :environment do
  repos = YAML.safe_load(File.open('config/repositories.yml'))

  id_names = Hash[repos.map { |k, v| [k, v['name']] }]

  id_names.each do |k, v|
    r = Repository.find_or_create_by(repository_id: k) do |r|
      puts "creating #{k}"
      r.update_attribute(:name, v)
    end
  end
end
