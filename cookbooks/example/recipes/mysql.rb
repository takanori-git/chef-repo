# 0.インクルード
include_recipe "example"

# 1. MySqlのインストール
package "mysql-server" do
  action :install
end

# 2. my.confのアップロード
cookbook_file "/etc/my.cnf"

# 3. MySqlのサービス起動
service "mysqld" do
  action [ :enable, :start ]
end

# 4.rootユーザにパスワードを設定
execute "set root password" do # update mysql.userはmysqlにログインしないといけないので。
  command <<-EOC
    mysqladmin -u root password 'password'
  EOC
  only_if "mysql -u root -e 'show databases;'"
end

# 5. DB初期化用スクリプトのアップロード
cookbook_file "/tmp/db_initialize.sql"

# 6. DB初期化
# 日本語をレシピに記載するとなぜか「invalid multibyte char (UTF-8)」になるので別ファイルから読み込む形にした
execute "create database" do
  command <<-EOC
    mysql -u root -ppassword < /tmp/db_initialize.sql;
  EOC
  only_if "mysqladmin -u root -ppassword CREATE chef_test"
end

# 7. 権限追加
execute "grant privilege" do # 他サーバからログインされるので追加
  command <<-EOC
    mysql -u root -ppassword -e "\
      grant all privileges on *.* to root@192.168.33.10 identified by 'password';\
      # grant all privileges on *.* to root@192.168.33.11 identified by 'password';\
      # grant all privileges on *.* to root@192.168.33.12 identified by 'password';\
    "
  EOC
end