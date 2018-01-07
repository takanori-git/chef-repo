# frozen_string_literal: true
# This is a Chef recipe file. It can be used to specify resources which will
# apply configuration to a server.

log "Welcome to Chef, #{node['example']['name']}!" do
  level :info
end

link "/etc/localtime" do
  to "/usr/share/zoneinfo/Asia/Tokyo"
  link_type :symbolic
end
