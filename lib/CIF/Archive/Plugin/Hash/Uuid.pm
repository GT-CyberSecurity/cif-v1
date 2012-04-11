package CIF::Archive::Plugin::Hash::Uuid;
use base 'CIF::Archive::Plugin::Hash';

use strict;
use warnings;

__PACKAGE__->table('hash_uuid');

sub prepare {
    my $class = shift;
    my $data = shift;
    return unless(lc($data) =~ /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/);
    return(1);
}

sub query {
    my $class = shift;
    my $data = shift;
    
    return unless($class->prepare($data->{'query'}));
    return $class->search_query(
        $data->{'query'},
        $data->{'confidence'},
        $data->{'limit'},
    );
}

1;