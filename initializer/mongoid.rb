require "mongoid"
Mongoid.load!("config/mongoid.yml")
I18n.enforce_available_locales = false

Mongoid.raise_not_found_error = false