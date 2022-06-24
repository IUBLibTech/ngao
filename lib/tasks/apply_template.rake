# frozen_string_literal: true

desc 'Re-apply XSLT template to update HTML versions of finding aids'
task apply_template: :environment do
  file_path = ARGV.second || "public/ead"
  file_path = Rails.root.join(file_path) + '**/*.xml' if File.extname(file_path) != ".xml"
  puts "Scanning: #{file_path}\n\n"
  Dir.glob(file_path) do |file|
    puts "Converting: #{file}"
    EadProcessor.convert_ead_to_html(file)
  end
end
