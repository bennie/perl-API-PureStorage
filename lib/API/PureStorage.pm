package API::PureStorage;

use warnings;
use strict;

$API::PureStorage::VERSION = 'VERSIONTAG';

sub new {
        my $class = shift @_;
        my $self = {};
        bless $self, $class;
}

1;
__END__
=head1 NAME

API::PureStorage - 

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

=head1 REQUESTS

=head1 BUGS AND SOURCE

	Bug tracking for this module: https://rt.cpan.org/Dist/Display.html?Name=API-PureStorage

	Source hosting: http://www.github.com/bennie/perl-API-PureStorage
	
=head1 VERSION

	API::PureStorage vVERSIONTAG (DATETAG)

=head1 COPYRIGHT

	(c) 2015-YEARTAG, Phillip Pollard <bennie@cpan.org>
    Published with permission of Pure Storage, Inc.

=head1 LICENSE

This source code is released under the "Perl Artistic License 2.0," the text of
which is included in the LICENSE file of this distribution. It may also be
reviewed here: http://opensource.org/licenses/artistic-license-2.0

=head1 AUTHORSHIP

Authored by Phillip Pollard in 2015.

=cut
