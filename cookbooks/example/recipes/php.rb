# 0. EPELリポジトリのインストール
package "epel-release.noarch" do
  action :install
end

# 1. Remiリポジトリのダウンロード
remote_file "/tmp/remi-release-6.rpm" do
  source "http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
  action :create
end

# 2. Remiリポジトリのインストール
rpm_package "remi-release-6" do
  source "/tmp/remi-release-6.rpm"
  action :install
end

# 3. Apache httpdとPHPのインストール
%w[
  httpd
  git
].each do |pkg|
  package "#{pkg}" do
    action :install
  end
end

%w[
  php
  php-mbstring
  php-pdo
  php-mysql
].each do |pkg|
  package "#{pkg}" do
    action :install
    options '--enablerepo=remi-php56'
  end
end

# 4. http.confの作成
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

# 5. Webページの配置
#    ファイル"index.php"を仮想サーバに配置する
cookbook_file "/var/www/html/index.php" do
  source "index.php"
  group "root"
  owner "root"
  mode "0644"
end

# 6. Apacheのサービス起動
service "httpd" do
  action [ :enable, :start ]
end

# 7.php.iniの作成
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

# 8.phpソースの配置
git "/var/www/html/web_app" do
  repository "https://github.com/takanori-git/web_app.git"
  reference "master"
  action :sync
  user "root"
end

# 9.mysqlでPermission deniedになるので解消する
selinux_policy_boolean 'httpd_can_network_connect' do
    value true
    # Make sure nginx is started if this value was modified
    notifies :start,'service[httpd]', :immediate
end

# include_recipe 'selinux_policy::install'

# bash "set selinux network" do
#  code <<-EOC
#    sudo setsebool -P httpd_can_network_connect 1
#  EOC
#  only_if "getsebool httpd_can_network_connect | grep 'httpd_can_network_connect --> off'"
#end

# 10.env情報の設定
template ".env" do
  source ".env.erb"
  path "/etc/.env"
  group "root"
  owner "root"
  mode "0644"
  variables(
    :mode=>node['example']['mode'],
    :db_ip=>node['example']['db_ip']
  )
end
# For more information, see the documentation: https://docs.chef.io/recipes.html
