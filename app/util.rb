require 'active_support/all'

# Turns a hash from { hi_there: true } to { "hiThere": true } to match engine
# syntax.
def camelcase(hash)
  hash.deep_transform_keys { |key| key.to_s.camelize(:lower) }
end

# Turns a hash from { "hiThere": true } to { hi_there: true } to match ruby
# like syntax.
def underscore(hash)
  hash.deep_transform_keys { |key| key.to_s.underscore.to_sym }
end
