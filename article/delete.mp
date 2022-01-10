has 'article_id' => (required => 1);

method handle() {
	my $dbh = Ws21::DBI->dbh();
	my $sth = $dbh->prepare("DELETE FROM wae01_article where article_id = ?");
	$sth->execute($.article_id);

	$m->redirect('/wae01/index');
}