=head1 NAME

=head1 FlowPDF::Component::CLI

=head1 AUTHOR

CloudBees

=head1 DESCRIPTION

FlowPDF::Component::CLI is an FlowPDF::Component that is responsible for command-line execution.

=head1 INIT PARAMS

To read more about init params see L<FlowPDF::ComponentManager>.

This component support following init params:

=over 4

=item (Required) workingDirectory

A parameter for working directory. CLI executor will chdir to this directory before commands execution.

=item (Optional) resultsDirectory

A parameter for output directory. Logs are being stored at this directory.

If no resultsDirectory parameter, defaults to workingDirectory parameter.

=back

=head1 USAGE

This component should be used in the following sequence:

=over 4

=item FlowPDF::Component::CLI creation.

=item FlowPDF::Component::CLI command creation.

=item Command execution.

=item Results procession.

=back

=head1 METHODS

=cut

package FlowPDF::Component::CLI;
use base qw/FlowPDF::BaseClass2/;

FlowPDF::Component::CLI->defineClass({
    workingDirectory    => FlowPDF::Types::Scalar(),
    resultsDirectory    => FlowPDF::Types::Scalar(),
    componentInitParams => FlowPDF::Types::Reference('HASH'),
});

use strict;
use warnings;
use FlowPDF::Helpers qw/isWin genRandomNumbers/;
use FlowPDF::Component::CLI::Command;
use FlowPDF::Component::CLI::ExecutionResult;
use FlowPDF::Log;
use Carp;


sub init {
    my ($class, $params) = @_;

    if (!$params->{workingDirectory}) {
        croak "Working Directory is expected for CLI interface initialization\n";
    }

    if (!$params->{resultsDirectory}) {
        $params->{resultsDirectory} = $params->{workingDirectory};
    }
    return $class->new($params);
}


=head2 newCommand($shell, $args)

=head3 Description

Creates an L<FlowPDF::Componen::CLI::Command> object that represents command line and being used by FlowPDF::Component::CLI executor.

=head3 Parameters

=over 4

=item (Required)(String) Shell for the command, or full path to the command that should be executed.

=item (Required)(ARRAY ref) An arguments that will be escaped and added to the command.

=back

=head3 Returns

=over 4

=item L<FlowPDF::Component::CLI::Command> object

=back

=cut

sub newCommand {
    my ($self, $shell, $args) = @_;

    my $command = FlowPDF::Component::CLI::Command->new($shell, @$args);

    return $command;
}


=head2 runCommand()

=head3 Description

Executes provided command and returns an L<FlowPDF::Component::CLI::ExecutionResult> object.

=head3 Parameters

=over 4

=item None

=back

=head3 Returns

=over 4

=item L<FlowPDF::Component::CLI::ExecutionResult>

=back

=cut

sub runCommand {
    my ($self, $command, $mergeOut) = @_;

    $mergeOut ||= 0;
    logInfo("Running command: " . $command->renderCommand());
    if (my $wd = $self->getWorkingDirectory()) {
        chdir($wd) or croak "Can't chdir to $wd";
    }
    return $self->_syscall($command, $mergeOut);

}

sub _syscall {
    my ($self, $commandObject, $mergeOut) = @_;

    my $command = $commandObject->renderCommand();
    my $result_folder = $self->getResultsDirectory();
    my $stderr_filename = 'command_' . genRandomNumbers(42) . '.stderr';
    my $stdout_filename = 'command_' . genRandomNumbers(42) . '.stdout';
    $command .= qq| 1> "$result_folder/$stdout_filename" 2> "$result_folder/$stderr_filename"|;
    if (isWin) {
        logDebug("MSWin32 detected");
        $ENV{NOPAUSE} = 1;
    }

    my $pid = system($command);
    my $retval = {
        stdout => '',
        stderr => '',
        code => $? >> 8,
    };

    open (my $stderr, "$result_folder/$stderr_filename") or croak "Can't open stderr file ($stderr_filename) : $!";
    open (my $stdout, "$result_folder/$stdout_filename") or croak "Can't open stdout file ($stdout_filename) : $!";
    $retval->{stdout} = join '', <$stdout>;
    $retval->{stderr} = join '', <$stderr>;
    close $stdout;
    close $stderr;

    # Cleaning up
    unlink("$result_folder/$stderr_filename");
    unlink("$result_folder/$stdout_filename");

    my $result = FlowPDF::Component::CLI::ExecutionResult->new($retval);
    return $result;
}




1;

