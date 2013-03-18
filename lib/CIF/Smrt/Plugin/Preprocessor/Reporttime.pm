package CIF::Smrt::Plugin::Preprocessor::Reporttime;

use strict;
use warnings;

use CIF qw/normalize_timestamp/;
use DateTime;

sub process {
    my $class   = shift;
    my $rules   = shift;
    my $rec     = shift;
    
    # detecttime is for legacy config support from v0
    # we just re-write it and drop it here
    my $dt = $rec->{'reporttime'} || $rec->{'detecttime'} || DateTime->from_epoch(epoch => time());
    
    # override the reporttime for "active lists" we might be tracking
    $dt = DateTime->from_epoch(epoch => time()) if($rules->{'refresh'});
    
    $dt = normalize_timestamp($dt);
    $dt = DateTime::Format::DateParse->parse_datetime($dt);
  
    if(my $detection = $rules->{'detection'}){
        if(lc($detection) eq 'hourly'){
            $dt = $dt->ymd().'T'.$dt->hour.':00:00Z';
        } elsif(lc($detection) eq 'daily') {
            $dt = $dt->ymd().'T00:00:00Z';
        } elsif(lc($detection) eq 'monthly') {
            $dt = $dt->year().'-'.$dt->month().'-01T00:00:00Z';
        } elsif(lc($detection ne 'now')){
            $dt = $dt->ymd().'T00:00:00Z';
        }
    } else {
        $dt = $dt->ymd().'T'.$dt->hms().'Z';
    }

    $rec->{'reporttime'} = $dt;
    $rec->{'reporttime_epoch'} = DateTime::Format::DateParse->parse_datetime($dt)->epoch();
    return $rec; 
}

1;