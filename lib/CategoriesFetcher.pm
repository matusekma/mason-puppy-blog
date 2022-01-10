package CategoriesFetcher;
# CategoriesFetcher.pm

use strict;
use warnings;

my $LEVEL = 1; # default log level

sub fetchAll{
	my $dbh = Ws21::DBI->dbh();
	my $sth = $dbh->prepare("SELECT category_id, title, parent_category_id FROM wae01_category ORDER BY parent_category_id IS NULL DESC, category_id");
	$sth->execute();
	
   my %categoriesLookup;
	my @categories;
	my $count = 0;

	while (my $hr = $sth->fetchrow_hashref) {
		if($hr->{parent_category_id}) {
			my $index = $categoriesLookup{$hr->{parent_category_id}};
			push(@{ @categories[$index] }, $hr);
		} else {
			push(@categories, [$hr]);
			$categoriesLookup{$hr->{category_id}} = $count;
			$count = $count + 1;
		}
	}
	return @categories;
}

1;