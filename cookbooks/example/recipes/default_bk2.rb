# frozen_string_literal: true
# This is a Chef recipe file. It can be used to specify resources which will
# apply configuration to a server.

log "Welcome to Chef, #{node['example']['name']}!" do
  level :info
end

# localtime���o�b�N�A�b�v����
bash "change timezone" do
  code <<-EOC
    cp -p /etc/localtime /etc/localtime_bk;
  EOC
  # only_if { File.exists?("/etc/localtime") } localtime�͂Ȃ��Ȃ�Ȃ��̂ŕs�v
end

link "/etc/localtime" do
  to "/usr/share/zoneinfo/Asia/Tokyo"
  link_type :symbolic
end

# 0. EPEL���|�W�g���̃_�E�����[�h
package "epel-release.noarch" do
  action :install
end

# 1. Remi���|�W�g���̃_�E�����[�h
remote_file "/tmp/remi-release-6.rpm" do
  source "http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
  action :create
end

# 2. Remi���|�W�g���̃C���X�g�[��
rpm_package "remi-release-6" do
  source "/tmp/remi-release-6.rpm"
  action :install
end

# 3. Apache httpd��PHP�̃C���X�g�[��
%w[
  httpd
  php
  php-mbstring
].each do |pkg|
  package "#{pkg}" do
    action :install
    options '--enablerepo=remi-php56'
  end
end

# 4. http.conf�̍쐬
template "httpd.conf" do
  source "httpd.conf.erb"
  path "/etc/httpd/conf/httpd.conf"
  group "root"
  owner "root"
  mode "0644"
  variables(
    :admin=>node['example']['admin'],
    :servername=>node['example']['servername']
  )
end

# 5. Web�y�[�W�̔z�u
#   �t�@�C��"index.php"�����z�T�[�o�ɔz�u����
cookbook_file "/var/www/html/index.php" do
  source "index.php"
  group "root"
  owner "root"
  mode "0644"
end

# 6. Apache�̃T�[�r�X�N��
service "httpd" do
  action [ :enable, :start ]
end

template "php.ini" do
  source "php.ini.erb"
  path "/etc/php.ini"
  group "root"
  owner "root"
  mode "0644"
  variables(
    :timezone=>node['example']['timezone']
  )
end

# For more information, see the documentation: https://docs.chef.io/recipes.html
