# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_acts_as_freetaggable_session',
  :secret      => '5b85e3bf8b8670549380ac742fb603b850369cf437d60c7dc47c8aeb06cf5f921dded2d06e35eee41b6df43506918551f2d23e6a02255c858e01a8a7a01e4180'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
