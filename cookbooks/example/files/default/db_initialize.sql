USE chef_test;
CREATE TABLE term ( id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, type TINYINT, item VARCHAR(20), description VARCHAR(200) );
INSERT INTO term (type, item, description) VALUES (1, 'Chef', 'サーバ構成自動化のためのツール');
INSERT INTO term (type, item, description) VALUES (1, 'Chef Client', '各Nodeにインストールされ、プロビジョニングを実施するクライアントエージェント');
INSERT INTO term (type, item, description) VALUES (1, 'Chef Server', 'プロビジョニングに必要な設定ファイルを保持するサーバ');
INSERT INTO term (type, item, description) VALUES (1, 'chef-zero', 'Chef Serverのスタンドアロン版');
INSERT INTO term (type, item, description) VALUES (1, 'chef-solo', 'Chef Serverのスタンドアロン版。deprecated');
INSERT INTO term (type, item, description) VALUES (2, 'Vagrant', '仮想環境(VirtualBox/VMware)のフロントエンドツール');
