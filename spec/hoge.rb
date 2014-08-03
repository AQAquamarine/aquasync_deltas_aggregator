require 'aquasync_model'

class Hoge
  include Aquasync::Base

  field :hoge

  def aq_commit_deltas(deltas, opts)
  end

  def aq_deltas(ust, opts)
  end
end