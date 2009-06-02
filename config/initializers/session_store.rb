# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_acts_as_freetaggable_session',
  :secret      => '18c6c85c9ee8f5570c82200fff192b4d4ab7039948822c5efd58bf6eaedc779d4e5a377a5ac856681b3cbfff7c7a72fd625269f0257db761a0f5df93eeb52b4a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
