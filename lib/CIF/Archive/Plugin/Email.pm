package CIF::Archive::Plugin::Email;
use base 'CIF::Archive::Plugin';

use strict;
use warnings;

use Module::Pluggable require => 1, search_path => [__PACKAGE__];
use Regexp::Common qw/URI/;

__PACKAGE__->table('email');
__PACKAGE__->columns(Primary => 'id');
__PACKAGE__->columns(Essential => qw/id uuid guid confidence detecttime created/);
__PACKAGE__->sequence('email_id_seq');


sub is_email {
    my $e = shift;
    return unless($e);
    return if($e =~ /^$RE{'URI'}/ || $e =~ /^$RE{'URI'}{'HTTP'}{-scheme => 'https'}$/);
    return unless(lc($e) =~ /^[a-z0-9_.-]+\@[a-z0-9.-]+\.[a-z0-9.-]{2,5}$/);
    return(1);
}

sub insert {
    my $class = shift;
    my $data = shift;
    
    my @ids;
    my $addresses = $class->iodef_addresses($data->{'data'});
    foreach my $address (@$addresses){
        my $addr = lc($address->get_content());
        next unless(is_email($addr));
        my $id = $class->SUPER::insert({
            uuid    => $data->{'uuid'},
            guid    => $data->{'guid'},
            confidence  => $data->{'confidence'},
        });
        push(@ids,$id);
    }
    return(undef,\@ids);
        
}

1;