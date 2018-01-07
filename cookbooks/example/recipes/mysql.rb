# 0.�C���N���[�h
include_recipe "example"

# 1. MySql�̃C���X�g�[��
package "mysql-server" do
  action :install
end

# 2. my.conf�̃A�b�v���[�h
cookbook_file "/etc/my.cnf"

# 3. MySql�̃T�[�r�X�N��
service "mysqld" do
  action [ :enable, :start ]
end

# 4.root���[�U�Ƀp�X���[�h��ݒ�
execute "set root password" do # update mysql.user��mysql�Ƀ��O�C�����Ȃ��Ƃ����Ȃ��̂ŁB
  command <<-EOC
    mysqladmin -u root password 'password'
  EOC
  only_if "mysql -u root -e 'show databases;'"
end

# 5. DB�������p�X�N���v�g�̃A�b�v���[�h
cookbook_file "/tmp/db_initialize.sql"

# 6. DB������
# ���{������V�s�ɋL�ڂ���ƂȂ����uinvalid multibyte char (UTF-8)�v�ɂȂ�̂ŕʃt�@�C������ǂݍ��ތ`�ɂ���
execute "create database" do
  command <<-EOC
    mysql -u root -ppassword < /tmp/db_initialize.sql;
  EOC
  only_if "mysqladmin -u root -ppassword CREATE chef_test"
end

# 7. �����ǉ�
execute "grant privilege" do # ���T�[�o���烍�O�C�������̂Œǉ�
  command <<-EOC
    mysql -u root -ppassword -e "\
      grant all privileges on *.* to root@192.168.33.10 identified by 'password';\
      # grant all privileges on *.* to root@192.168.33.11 identified by 'password';\
      # grant all privileges on *.* to root@192.168.33.12 identified by 'password';\
    "
  EOC
end