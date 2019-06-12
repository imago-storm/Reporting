package FlowPlugin::Reporting;
use strict;
use warnings;
use base qw/FlowPDF/;
use Data::Dumper;
# Feel free to use new libraries here, e.g. use File::Temp;

# Service function that is being used to set some metadata for a plugin.
sub pluginInfo {
    return {
        pluginName    => '@PLUGIN_KEY@',
        pluginVersion => '@PLUGIN_VERSION@',
        configFields  => ['config'],
        configLocations => ['ec_plugin_cfgs']
    };
}

# Auto-generated method for the procedure Sample Procedure/Sample Procedure
# Add your code into this method and it will be called when step runs
sub sampleProcedure {
    my ($pluginObject) = @_;
    my $context = $pluginObject->newContext();
    print "Current context is: ", $context->getRunContext(), "\n";
    my $params = $context->getStepParameters();
    print Dumper $params;

    my $configValues = $context->getConfigValues();
    print Dumper $configValues;

    my $stepResult = $context->newStepResult();
    print "Created stepresult\n";
    $stepResult->setJobStepOutcome('warning');
    print "Set stepResult\n";

    $stepResult->setJobSummary("See, this is a whole job summary");
    $stepResult->setJobStepSummary('And this is a job step summary');

    $stepResult->apply();
}
## === step ends ===
# Please do not remove the marker above, it is used to place new procedures into this file.


sub collectReportingData {
    my $self = shift;
    my $params = shift;
    my $stepResult = shift;

    die 'Not implemented yet';

    
        my $buildReporting = FlowPDF::ComponentManager->loadComponent('FlowPlugin::Reporting::Reporting', {
            reportObjectTypes     => [ 'build' ],
            metadataUniqueKey     => 'fill me in',
            payloadKeys           => [ 'fill me in' ]
        }, $self);
        $buildReporting->CollectReportingData();
    
}
## === feature step ends ===


1;