<%class>
has 'category_id';
has 'maintitle' => (default => 'WAE Group 01');
has 'username';
has 'password';
</%class>

<%augment wrap>
  <html>
    <head>
      <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
      
      <link rel="stylesheet" href="/wae01/static/scss/main.min.css">
      <script src="/static/js/ckeditor/ckeditor.js"></script>

      <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
      <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

% $.Defer {{
      <title><% $.maintitle %></title>
% }}
    </head>
    <body>
      <& top.mi, category_id => $.category_id, username => $.username, password => $.password &>
      <% inner() %>
      <& footer.mi, grp => '01' &>
    </body>
  </html>
</%augment>

<%flags>
extends => undef
</%flags>

<%init>
	use lib '/usr/local/htdocs/ws21/comps/wae01/lib';

  my $conn = Ws21::DBI->conn();
	my $sconn = Ws21::DBI->session_conn();
</%init>
