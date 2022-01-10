has 'title';
has 'category';
has 'textarea';
has 'excerpt';
has 'article_id';

method handle() {
	# match selected category with its id
	my $dbh = Ws21::DBI->dbh();
	my $sth = $dbh->prepare("SELECT category_id FROM wae01_category WHERE title=?");
	$sth->execute($.category);

	my @category;
	while (my $hr = $sth->fetchrow_hashref) {
	  push(@category, $hr);
	}
	my $category_id = $category[0]->{'category_id'};

	# extract and format excerpt
	my $excerpt = join ' ', (split /\s+/, $.excerpt)[0..100];
	$excerpt =~ s/<.+?>//g;
	$excerpt = $excerpt . '[...]';

	# extract and format title
	my $title = join '', $.title;
	$title =~ s/<.+?>//g;

	# store in database
	$sth = $dbh->prepare("UPDATE wae01_article SET category_id=?, title=?, user_id=?, excerpt=?, content=? WHERE article_id=?");
	$sth->execute($.category, $title, $m->session->{user_id}, $excerpt, $.textarea, $.article_id);

	$m->redirect('/wae99/index');
}
