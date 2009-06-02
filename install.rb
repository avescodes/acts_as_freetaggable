# Install hook code here

# Make symlinks for acts_as_category and has_many_polymorphs unless they exist
%W| acts_as_category has_many_polymorphs |.each do |plugin|
  plugin_path = Pathname.new(File.dirname(__FILE__))
  target = Rails.root + "vendor/plugins/#{plugin}"
  target.make_symlink(plugin_path) unless target.exist?
end

# Generate db migration for tag and taggings? 
Rake::Task["freetaggable:copy_migrations"]