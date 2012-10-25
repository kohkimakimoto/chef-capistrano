name "local"
description "Local Development Server Role Configuration"
run_list(
  "role[base]"
)

default_attributes({
  :role            => 'local',
  :nodename        => 'localhost'
})

