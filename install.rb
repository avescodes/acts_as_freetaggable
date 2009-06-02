# Install hook code here

# Make symlinks for acts_as_category and has_many_polymorphs unless they exist
Rake::Task["freetaggable:symlink_plugins"]

# Generate db migration for tag and taggings? 
Rake::Task["freetaggable:copy_migrations"]