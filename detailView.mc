<%class>
  has 'articleId'  => (required => 1);
</%class>
    <main class="container-fluid">
        <article class="post page-container">
            <header>
                <div class="post_info">
                    <p class="post_category"> Categorie: <& fetchCategory.mi, category_id => $article->{'category_id'} &></p>
                    <p class="post_time"> Date: <% $article->{'timestamp'} %></p>
                    <p class="post_author"> Writte by: <& fetchAuthor.mi, user_id => $article->{'user_id'} &></p>    
                </div>
                <div class="post_title"><% $article->{'name'} %></div>
              <img class="post_image" src="<% $article->{'image_url'} %>"><!--TODO add url-->
            </header>
            <main class="post_content">
                <% $article->{'description'} %>
            </main>
        </article>
    </main>
<%init>
    my $dbh = Ws21::DBI->dbh();
    my $stmt = $dbh->prepare("SELECT article_id, name, image_url, excerpt, description, timestamp, category_id, user_id, status from wae01_article where article_id=?");
    $stmt->execute($.articleId);

    my @articles;
    while (my $line = $stmt->fetchrow_hashref) {
        push(@articles, $line);
    }
    my $article = $articles[0];

</%init>