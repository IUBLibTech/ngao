# frozen_string_literal: true

desc 'Re-apply XSLT template to update HTML versions of finding aids'
# USAGE:
#   1. Update all finding aids on the system (default to public/ead)
#       `bundle exec rake apply_template`
#   2. Update finding aids for a specific repo (or any directory)
#        `bundle exec rake apply_template data/atm`
#   3. Update a single finding aid from a source EAD
#        `bundle exec rake apply_template public/ead/VAB6923.xml`

task apply_template: :environment do
  ARGV.each { |a| task a.to_sym do ; end }
  file_path = ARGV[1] || "public/ead"
  file_path = Rails.root.join(file_path) + '**/*.xml' if File.extname(file_path) != ".xml"
  puts "Scanning: #{file_path}\n\n"
  Dir.glob(file_path) do |file|
    puts "Converting: #{file}"
    EadProcessor.convert_ead_to_html(file)
  end
end
