name "base"
description "Server Configuration Base"
run_list(
  "recipe[sample]"
)

default_attributes({
  :role            => 'base',
  :nodename        => nil
})
