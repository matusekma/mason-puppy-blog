<%class>
  has 'username';
  has 'password';
</%class>

<& index.mc, username=>$.username, password=>$.password &>

<%init>
	my $dbh = Ws21::DBI->dbh();
	my $sth = $dbh->prepare("SELECT user_id FROM wae01_user WHERE username=? AND password=?");
	$sth->execute($.username, $.password);
  my $user = $sth->fetchrow_hashref;


  if (defined $user->{'user_id'} && $user->{'user_id'} > 0) {
    $m->session->{user_id} = $user->{'user_id'};
    $m->redirect('/wae01/index');
  }
</%init>
