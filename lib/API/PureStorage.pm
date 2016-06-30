package API::PureStorage;

use Data::Dumper;
use REST::Client;
use JSON;
use Net::SSL;

use warnings;
use strict;

$API::PureStorage::VERSION = 'VERSIONTAG';

our %ENV;
$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

my $debug = 0;

sub new {
    my $class = shift @_;
    my $self = {
        cookie_file => '/tmp/cookies.txt',
        host => $_[0],
        token => $_[1]
    };
    bless $self, $class;
 
    my $client = REST::Client->new( follow => 1 );
    $client->setHost('https://'.$self->{host});

    $client->addHeader('Content-Type', 'application/json');

    $client->getUseragent()->cookie_jar({ file => $self->{cookie_file} });
    $client->getUseragent()->ssl_opts(verify_hostname => 0);

    $self->{client} = $client;

    # Check API compatibility

    my @versions = $self->version();

    my %api_versions;
    for my $version (@versions) {
        $api_versions{$version}++;
    }

    my $api_version = $api_versions{'1.4'} ? '1.4' :
                      $api_versions{'1.3'} ? '1.3' :
                      $api_versions{'1.1'} ? '1.1' :
                      $api_versions{'1.0'} ? '1.0' :
                      undef;

    unless ( $api_version ) {
      die "API version 1.3 or 1.4 is not supported by host: $self->{host}\n";
    }
    
    $self->{api_version} = $api_version;

    ### Set the Session Cookie

    my $ret = $self->_api_post("/api/$api_version/auth/session", { api_token => $self->{token} });

    return $self;
}

sub DESTROY {
  my $self = shift @_;
  my $ret = $self->{client}->DELETE("/api/$self->{api_version}/auth/session");
  unlink $self->{cookie_file};
}

### Methods

sub version {
    my $self = shift @_;
    my $ref = $self->_api_get('/api/api_version');
    return wantarray ? @{$ref->{version}} : $ref->{version};
}

### Subs

sub _api_get {
    my $self = shift @_;
    my $url = shift @_;
    my $ret = $self->{client}->GET($url);
    my $num = $ret->responseCode();
    my $con = $ret->responseContent();
    if ( $num == 500 ) {
        die "API returned error 500 for '$url' - $con\n";
    }
    if ( $num != 200 ) {
        die "API returned code $num for URL '$url'\n";
    }
    print 'DEBUG: GET ', $url, ' -> ', $num, ":\n", Dumper(from_json($con)), "\n" if $debug;
    return from_json($con);
}

sub _api_post {
    my $self = shift @_;
    my $url = shift @_;
    my $data = shift @_;
    my $ret = $self->{client}->POST($url, to_json($data));
    my $num = $ret->responseCode();
    my $con = $ret->responseContent();
    if ( $num == 500 ) {
        die "API returned error 500 for '$url' - $con\n";
    }
    if ( $num != 200 ) {
        die "API returned code $num for URL '$url'\n";
    }
    print 'DEBUG: POST ', $url, ' -> ', $num, ":\n", Dumper(from_json($con)), "\n" if $debug;
    return from_json($con);
}

1;
__END__
=head1 NAME

API::PureStorage - Interacting with Pure Storage devices

=head1 SYNOPSIS

  my $pure = new API::PureStorage ($host, $api_token);

=head1 DESCRIPTION

This module is a wrapper around the Pure Storage API for their devices.

It currently supports a limited subset of commands in API v1.4 and earlier.

=head1 METHODS

=head2 version()

    my @versions = $pure->version()
    my $versions_ref = $pure->version()

Returns an array or arrayref (depending on requested context) of API versions
supported by the storage array.

=head1 SEE ALSO

    http://www.purestorage.com/

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

Authored by Phillip Pollard.

=cut
