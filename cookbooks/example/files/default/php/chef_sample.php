<html>
  <head>
    <h1>Chefのテストページ</h1>
    <link rel="stylesheet" href="css/chef_test.css">
  </head>
  <body>
    <form method="POST">
      <div>
      <label>
        <input id="type" type="radio" name="type" value="1" <?php
if (empty($_POST['type']) || $_POST['type']=='1') { print 'checked'; } ?>/>Chef
      </label>
      <label>
        <input id="type" type="radio" name="type" value="2" <?php
if (empty($_POST['type']) || $_POST['type'] == '2') { print 'checked'; }?>/>Vagrant
      </label>
      <input type="submit" value="検索">
      </div>
    </form>
    <hr/>
    <table>
      <tr><th class="c1">項目</th><th class="c2">説明</th></tr>
<?php
if (empty($_POST['type'])) {
  return;
}
$dsn = 'mysql:dbname=chef_test; host=127.0.0.1; charset=utf8';
$usr = 'root';
$passwd = 'password';
try {
  $db = new PDO($dsn, $usr , $passwd);
  $stt = $db->prepare('SELECT item,description FROM description WHERE type=:type');
  $stt->bindValue(':type', $_POST['type']);
  $stt->execute();
  while($row = $stt->fetch(PDO::FETCH_ASSOC)) {
?>
      <tr><td><?=$row['item']?></td><td><?=$row['description']?></td></tr>
<?php
  }
} catch (PDOException $e) {
  print "接続エラー:{$e->getMessage()}";
} catch (Exception $e){
  print "何らかのエラー";
} finally {
  $db = null;
}
?>
    </table>
  </body>
</html>
