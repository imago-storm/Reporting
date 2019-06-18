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


## === step ends ===
# Please do not remove the marker above, it is used to place new procedures into this file.


sub collectReportingData {
    my $self = shift;
    my $params = shift;
    my $stepResult = shift;

    my $buildReporting = FlowPDF::ComponentManager->loadComponent('FlowPlugin::Reporting::Reporting', {
        reportObjectTypes     => [ 'build' ],
        metadataUniqueKey     => int rand 89898,
        payloadKeys           => [ 'buildNumber' ]
    }, $self);
    $buildReporting->CollectReportingData();
}
## === feature step ends ===


1;
