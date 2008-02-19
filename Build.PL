use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'POE::Component::WebService::Validator::HTML::W3C',
    license             => 'perl',
    dist_author         => 'Zoffix Znet <zoffix@cpan.org>',
    dist_version_from   => 'lib/POE/Component/WebService/Validator/HTML/W3C.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Carp'                             => 1.04,
        'POE'                              => 0.9999,
        'POE::Wheel::Run'                  => 1.2179,
        'POE::Filter::Reference'           => 1.2187,
        'POE::Filter::Line'                => 1.1920,
        'WebService::Validator::HTML::W3C' => 0.22,
    },
    add_to_cleanup      => [ 'POE-Component-WebService-Validator-HTML-W3C-*' ],
    create_makefile_pl => 'traditional',
);

my $do_network_tests
= $builder->prompt(make_network_test_prompt_message(), 'y');

my $net_test_file = 'network_test_enabled';
unlink $net_test_file;

if ( lc $do_network_tests eq 'y' ) {
   open my $net_test, '>', $net_test_file
        or die "Could not create marker file ($!)\nAnswer 'n' to the "
            . "network tests to quickly avoid this\n";

   my $validator_uri = $builder->prompt(
    make_validator_prompt_message(), 'http://validator.w3.org/check',
   );

   print $net_test $validator_uri . $/;
   close $net_test;
}

$builder->create_build_script();



sub make_network_test_prompt_message {

    my $message = <<'END_PROMT_MESSAGE';

###########################################################
###########################################################

NOTE: Validation tests will require you to have access to a
W3C HTML validator.
It may be a LOCAL version, you will be prompted for a URI
to a different validator later.

Do you want to perform validation tests? [Y/n]: 
END_PROMT_MESSAGE

    chomp $message;
    return $message;
}

sub make_validator_prompt_message {
    my $message = <<'END_MESSAGE';

*************************************************************
By default I will use http://validator.w3.org/check validator
to perform the tests.
If you want to use a different one (perhaps the one installed
locally) Now it is your chance to give me a link to its CGI

Validator URI: 
END_MESSAGE

    chomp $message;
    return $message;
}
