has 'title';
has 'category';
has 'textarea';
has 'excerpt';

method handle() {
	# extract and format excerpt
	my $excerpt = join ' ', (split /\s+/, $.excerpt)[0..100];
	$excerpt =~ s/<.+?>//g;
	$excerpt = $excerpt . '[...]';

	# extract and format title
	my $title = join '', $.title;
	$title =~ s/<.+?>//g;

	my $dbh = Ws21::DBI->dbh();
	my $sth = $dbh->prepare("INSERT INTO wae01_article (category_id, title, user_id, excerpt, content) VALUES (?,?,?,?,?)");
 	$sth->execute($.category, $title, $m->session->{user_id}, $excerpt, $.textarea);
	$m->session->{message} = sprintf("Article '%s' saved.", $title);
	$m->redirect('/wae99/index');
}
