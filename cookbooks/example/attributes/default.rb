# frozen_string_literal: true
# This is a Chef attributes file. It can be used to specify default and override
# attributes to be applied to nodes that run this cookbook.

# Set a default name
default['example']['name'] = 'Sam Doe'

# For further information, see the Chef documentation (https://docs.chef.io/essentials_cookbook_attribute_files.html).

default['example']['admin'] = 'root@test-domain.com'
default['example']['servername'] = 'www.test-domain.com'
default['example']['timezone'] = 'Asia/Tokyo'
default['example']['mode'] = 'not_set'
default['example']['db_ip'] = ''
