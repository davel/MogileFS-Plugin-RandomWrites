package MogileFS::ReplicationPolicy::MultipleHostsRandom;
use strict;
use warnings;
use List::Util qw/ shuffle /;
use base 'MogileFS::ReplicationPolicy::MultipleHosts';

sub sort_devices {
    my ($self, $ideal, $desp, $fid) = @_;

    my $file = MogileFS::FID->new_from_db_row(Mgd::get_store()->read_store->file_row_from_fidid($fid));

    my @ideal = @{ $ideal };
    my @desp  = @{ $desp };

    @{ $ideal } = shuffle grep { $file->{length} <= $_->{mb_free}*1024*1024 || 0 } @ideal;

    if (!scalar(@{ $ideal })) {
        warn "no ideal devices appear to have ".$file->{length} ." bytes free";
        @{ $ideal } = shuffle @ideal;
    }

    @{ $desp } = shuffle grep { $file->{length} <= $_->{mb_free}*1024*1024 || 0 } @desp;
    if (!scalar(@{ $desp })) {
        unless (@{ $ideal }) {
            warn "no desperate devices appear to have ".$file->{length} ." bytes free" unless @{ $ideal };
        }
        @{ $desp } = shuffle @desp;
    }

    return;
}

1;
