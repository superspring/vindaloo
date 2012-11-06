use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    VERSION   => '0.03',
    PREREQ_PM => {
        'Mojolicious'                         => '3.54',
        'Mojolicious::Plugin::Authentication' => 0,
        'Mojolicious::Plugin::Authorization'  => 0,
        'Mojolicious::Plugin::Bcrypt'         => 0,
        'DBIx::Class'                         => 0,
        'HTML::FormHandler'                   => 0,
        'File::Basename'                      => 0,
        'File::Spec::Functions'               => 0,
        'TryCatch'                            => 0,
        'List::MoreUtils'                     => 0
    },
    test => { TESTS => 't/*.t' },
    EXE_FILES => [qw{script/vindaloo}]
);
