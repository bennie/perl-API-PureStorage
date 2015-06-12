use Test::Simple tests => 2;

use API::PureStorage;
ok(1);

my $ps = new API::PureStorage;
ok(defined $ps);