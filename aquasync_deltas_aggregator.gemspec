Gem::Specification.new do |gem|
  gem.name    = 'aquasync_deltas_aggregator'
  gem.version = '0.1.1'
  gem.date    = Date.today.to_s

  gem.summary = "An aggregator for pack DeltaPack and unpack DeltaPack."
  gem.description = "To help implementation of Aquasync."
  gem.licenses = "MIT"

  gem.authors  = ['kaiinui']
  gem.email    = 'me@kaiinui.com'
  gem.homepage = 'https://github.com/AQAquamarine/aquasync_deltas_aggregator'

  gem.add_dependency 'simple_uuid', ["~> 0.4"]
  gem.add_dependency 'aquasync_model', ["~> 0.1"]
  gem.add_development_dependency 'rspec', ["~> 3.0"]
  gem.add_development_dependency 'guard-rspec', ["~>4.3"]
  gem.add_development_dependency 'factory_girl', ["~> 4.4"]
  gem.add_development_dependency 'database_cleaner', ["~> 1.3"]

  gem.files = ["lib/aggregators/deltas_aggregator.rb", "lib/delta_pack/delta_pack_builder.rb", "lib/delta_pack/delta_pack_unpacker.rb", "lib/aquasync_deltas_aggregator.rb"]
end