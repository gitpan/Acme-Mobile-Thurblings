use Module::Build;

my $build = Module::Build->new
    (
     module_name => 'Acme::Mobile::Thurblings',
     license => 'perl',
     requires => {
       'perl'                       => '5.6.1',
       'Carp'                       => 0,
       'YAML'                       => 0.35,
     },
     recommends => {
     },
     build_requires => {
       'IO::File'                   => 0,
       'Test::More'                 => 0,
     },
     create_makefile_pl => 'traditional',
     dist_author        => 'Robert Rothenberg <rrwo at cpan.org>',
     sign               => 1,
);

$build->create_build_script;
