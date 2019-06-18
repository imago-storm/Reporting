package FlowPlugin::Reporting::Reporting;
use Data::Dumper;
use base qw/FlowPDF::Component::EF::Reporting/;
use FlowPDF::Log;
use strict;
use DateTime;
use warnings;

sub compareMetadata {
    my ($self, $metadata1, $metadata2) = @_;

    print Dumper $metadata1, $metadata2;

    my $value1 = $metadata1->getValue();
    my $value2 = $metadata2->getValue();
    # Implement here logic of metadata values comparison.
    # Return 1 if there are newer records than record to which metadata is pointing.
    return 1;
}


sub initialGetRecords {
    my ($self, $pluginObject, $limit) = @_;

    # build records and return them
    my $records = [{
        buildNumber => int rand 998889,
        test1 => 'test',
    }];
    # my $records = pluginObject->yourMethodTobuildTheRecords($limit);
    return $records;
}


sub getRecordsAfter {
    my ($self, $pluginObject, $metadata) = @_;

    # build records using metadata as start point using your functions
    # my $records = pluginObject->yourMethodTobuildTheRecordsAfter($metadata);
    my $records = [{
        buildNumber => int rand 89128912,
        test1 => 'test'
    }];
    return $records;
}

sub getLastRecord {
    my ($self, $pluginObject) = @_;

    my $lastRecord = {buildNumber => int rand 938193};
    return $lastRecord;
}

sub buildDataset {
    my ($self, $pluginObject, $records) = @_;

    my $dataset = $self->newDataset(['build']);
    my $context = $pluginObject->getContext;
    my $params = $context->getRuntimeParameters();

    for my $row (@$records) {
        # now, data is a pointer, you need to populate it by yourself using it's methods.
        my $data = $dataset->newData({
            reportObjectType => 'build',
        });

        my $today = DateTime->now;
        # Just some random data
        $row->{source} = "Test Reporting";
        $row->{pluginName} = '@PLUGIN_NAME@';
        $row->{projectName} = $context->retrieveCurrentProjectName;
        $row->{releaseProjectName} = $params->{releaseProjectName};
        $row->{releaseName} = $params->{releaseName};
        $row->{timestamp} = $today->ymd . 'T' . $today->hms . '.000Z';
        my $status = rand() > 0.5 ? 'SUCCESS' : 'FAILURE';
        $row->{buildStatus} = $status;
        $row->{pluginConfiguration} = $params->{config};
        $row->{endTime} = $today->ymd . 'T' . $today->hms . '.000Z';
        $row->{startTime} = $today->ymd . 'T' . $today->hms . '.000Z';
        $row->{duration} = (int rand 9839) * 1000;

        for my $k (keys %$row) {
            $data->{values}->{$k} = $row->{$k};
        }

    }
    return $dataset;
}



1;
