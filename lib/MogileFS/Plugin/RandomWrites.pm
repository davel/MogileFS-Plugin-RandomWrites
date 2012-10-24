package MogileFS::Plugin::RandomWrites;

use strict;
use warnings;

our $VERSION = "0.02";

use MogileFS::Server;

use List::Util qw/ shuffle /;

sub load {
    MogileFS::register_global_hook("cmd_create_open_order_devices", \&cmd_create_open_order_devices) or die $!;
}

sub cmd_create_open_order_devices {
    my ($all_devices, $return_list) = @_;

    @{ $return_list } = shuffle grep { $_->should_get_new_files; } @{ $all_devices };
    return 1;
}

1;
__END__

=head1 NAME

MogileFS::Plugin::RandomWrites - Perl extension for blah blah blah

=head1 SYNOPSIS

In mogilefsd.conf

    plugins = RandomWrites

=head1 DESCRIPTION

This plugin cause MogileFS to distribute writes to a random device, rather than
concentrating on devices with the most space free.

=head1 SEE ALSO

L<MogileFS::Server>

=head1 AUTHOR

Dave Lambley, E<lt>davel@state51.co.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Dave Lambley

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
