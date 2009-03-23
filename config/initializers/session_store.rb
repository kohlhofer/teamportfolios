# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_teamportfolios_session',
  :secret      => 'd7acd0808ed9f4226ab508610896ae56ee348a2560cdcf16eaeba5bab422e7a8fbacfaf0ff4e650bb01f934764b004b53289b603824eb15d9aa967f933e9e3b1'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
