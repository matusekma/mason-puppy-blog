<%class>
  has 'article_id';
  has 'Save';
  has 'insert' => (default => 0);

  has 'title';
  has 'content' => (default => "<font face=Verdana>bitte hier den Text eingeben.\n</font>\n");
  has 'category_id';
  has 'excerpt';
  has 'image_url';
  has 'status';
</%class>

<div class="editor container">
<h2>
% if (defined($.article_id) && ($.insert==0)) {
Dokument <% $.article_id %> editieren
% } else {
Neues Dokument anlegen
% }
</h2>
% if (length($msg)) {
<p style="color:red;font-size:10px;"><% $msg %></p>
% }



<form name="editform"
method="post" enctype="application/x-www-form-urlencoded">

  <input type="hidden" name="article_id" value="<% $.article_id %>">
  <input type="hidden" name="insert" value="<% $.insert %>">

  <div class="form-group">
    <label for="title">Title</label>
    <input type="text" class="form-control" name="title" placeholder="Enter title" value="<% $.title %>">
  </div>
  <div class="form-group">
    <label for="image">Main Image (Url)</label>
    <input type="text" class="form-control" name="image_url" placeholder="Enter Image Link" value="<% $.image_url %>">
  </div>
  <div class="form-group">
    <label for="excerpt">Excerpt</label>
    <input type="text" class="form-control" name="excerpt" placeholder="Enter Excerpt" value="<% $.excerpt %>">
  </div>
  <div class="form-group form-check">
      <input type='hidden' value='0' name='status'>
      <input class="form-check-input" type="checkbox" name="status" id="status" value="1" <% $.status == 1 ? 'checked' : '' %>>
      <label class="form-check-label" for="status">
        Publish
      </label>
  </div>
  <div class="form-group">
    <label for="category_id">Category</label>
    <select name="category_id" class="form-control">
%   for my $top_index (0 .. $#categories) {
%     my $item = $categories[$top_index][0];  
      <option <% $.category_id == $item->{category_id} ? 'selected' : '' %> value="<% $item->{category_id} %>"><% $item->{title} %></option>
%  		for my $sub_index (1 .. $#{$categories[$top_index]}) {
%			my $item = $categories[$top_index][$sub_index];
      <option <% $.category_id == $item->{category_id} ? 'selected' : '' %> value="<% $item->{category_id} %>"> - <% $item->{title} %></option>
% 	 	}	 
%  }
    </select>
  </div>

  <textarea name="content" id="content"><% $.content %></textarea>
<script>
	// Replace the <textarea id="content"> with a CKEditor
	// instance, using default configuration.
	CKEDITOR.replace('content',{
		width   : '560px',
		height  : '400px'
	});
</script>

  <input name="Save" type="submit" class="btn btn-primary" value="Speichern">
  <input type="reset" class="btn btn-warning" name="Cancel" value="Cancel"><!-- onClick="window.close()" -->
</form>
</div>
<%init>
use Data::Dumper;
use CGI;

my $dbh = Ws21::DBI->dbh();
my $cgi = new CGI;

my $msg = "Welcome to the WCM content editor.";

use CategoriesFetcher;	
my @categories = CategoriesFetcher::fetchAll();

if ($.Save) {
# Speichern wurde gedrückt...
  if ($.insert == 1) {
  # Datensatz aus Formularfeldern in Datenbank einf�gen
    my $sth = $dbh->prepare("INSERT INTO wae01_article (name, image_url, excerpt, description, category_id, status, user_id, timestamp) values (?,?,?,?,?,?,?,NOW())");
    $sth->execute($.title,$.image_url,$.excerpt,$.content,(($.category_id > 0)?$.category_id:undef),$.status, $m->session->{user_id});
    $msg = "Datensatz ". $.article_id ." neu in DB aufgenommen.".$sth->rows();
#    $.insert(0);
  } else {
  # Datensatz in Datenbank ändern
    my $sth = $dbh->prepare("UPDATE wae01_article SET name = ?, image_url = ?, excerpt = ?, description = ?, category_id = ?, status = ? WHERE article_id = ?");
    $sth->execute($.title,$.image_url,$.excerpt,$.content,$.category_id,$.status,$.article_id);
    $msg = "Datensatz " . $.article_id ." in DB ver&auml;ndert.".$sth->rows();
  }
} elsif ($.article_id) {
# id erkannt, daten aus Datenbank lesen
  my $sth = $dbh->prepare("SELECT article_id, name, image_url, excerpt, description, category_id, status from wae01_article WHERE article_id = ?");
  $sth->execute($.article_id);
  my $res = $sth->fetchrow_hashref();
  $.content($res->{description} || $.content);
  $.title($res->{name});
  $.category_id($res->{category_id});
  $.status($res->{status});
  $.image_url($res->{image_url});
  $.excerpt($res->{excerpt});

  $msg = "Datensatz " . $.article_id . " aus DB gelesen.".((defined($res) && scalar(keys(%$res)))?1:0);
} else {
  # keine ID, neues Dokument erstellen
  $.insert(1);
}
</%init>
