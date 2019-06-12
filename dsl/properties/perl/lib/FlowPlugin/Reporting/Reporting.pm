package FlowPlugin::Reporting::Reporting;
use Data::Dumper;
use base qw/FlowPDF::Component::EF::Reporting/;
use FlowPDF::Log;
use strict;
use warnings;

# todo more sample boilerplate
sub compareMetadata {
    my ($self, $metadata1, $metadata2) = @_;

    die 'Not implemented';
}

sub initialGetRecords {
    my ($self, $pluginObject, $limit) = @_;

    die 'Not implemented';
}

sub getRecordsAfter {
    my ($self, $pluginObject, $metadata) = @_;

    die 'Not implemented';
}

sub getLastRecord {
    my ($self, $pluginObject) = @_;

    die 'Not implemented';
}

sub buildDataset {
    my ($self, $pluginObject, $records) = @_;

    die 'Not implemented';
    return $dataset;
}



1;