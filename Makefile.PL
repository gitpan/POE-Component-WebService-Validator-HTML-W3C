use 5.008008;
use ExtUtils::MakeMaker;

my $do_network_tests = prompt( make_network_test_prompt_message(), 'y');

my $net_test_file = 'network_test_enabled';
unlink $net_test_file;

if ( lc $do_network_tests eq 'y' ) {
   open my $net_test, '>', $net_test_file
        or die "Could not create marker file ($!)\nAnswer 'n' to the "
        	. "network tests to quickly avoid this\n";

   my $validator_uri = prompt(
    make_validator_prompt_message(), 'http://validator.w3.org/check',
   );

   print $net_test $validator_uri . $/;
   close $net_test;
}

WriteMakefile(
    NAME              => 'POE::Component::WebService::Validator::HTML::W3C',
    VERSION_FROM      => 'lib/POE/Component/WebService/Validator/HTML/W3C.pm', 
    PREREQ_PM         => {
        'Test::More' => 0.74,
    POE     => 0.9999,
        'POE::Wheel::Run'        => 1.2179,
        'POE::Filter::Reference' => 1.2187,
        'POE::Filter::Line'      => 1.1920,
        'WebService::Validator::HTML::W3C' => 0.22,
   	 'Carp'             => 1.04,
	'XML::XPath'		=> 1.13,
    },
    
    ($] >= 5.005 ?
      (
          ABSTRACT_FROM  => 'lib/POE/Component/WebService/Validator/HTML/W3C.pm', 
           AUTHOR         => 'Zoffix Znet <zoffix@cpan.org>') : ()
       ),
);


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
