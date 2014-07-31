Aquasync DeltasAggregator
===

```
require 'aquasync_deltas_aggregator'

# @example Initialization
aggregator = DeltasAggregator.new
aggregator.regist_model_manager(Book, Author)

# @example Obtain a DeltaPack from registered models.
aggregator.pack_deltas

# @example Commit a DeltaPack to registered models.
aggregator.unpack_and_commit_delta_pack(delta_pack)
```

See also https://github.com/AQAquamarine/aquasync_model