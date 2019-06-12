=head1 NAME

FlowPDF::Types

=head1 AUTHOR

CloudBees

=head1 DESCRIPTION

This module provides type validation system for FlowPDF. This module is intended to be used by FlowPDF developers.

Each type has a method called match and describe. Match should accept a value that should be validated,
describe() returns a string with current object description, to be used, for example, as error message.

=head1 TYPES

=head2 FlowPDF::Types::Any

This type represents an any value.

%%%LANG=perl%%%

    my $any = FlowPDF::Types::Any();
    if ($any->match('any value') {
        print "Match!\n"
    }
    else {
        print "No match: ", $arrayref->describe(), "\n";
    }

%%%LANG%%%

=head2 FlowPDF::Types::ArrayrefOf

This type represents an array reference with other types as references.
For example, to check that you have an array reference of hashes.

%%%LANG=perl%%%

    my $arrayref = FlowPDF::Types::ArrayrefOf(FlowPDF::Types::Reference('HASH'));
    my $records = [
        {one => 'two'},
        {one => 'two'},
    ];
    if ($arrayref->match($records)) {
        print "Match!\n";
    }
    else {
        print "No match: ", $arrayref->describe(), "\n";
    }

%%%LANG%%%

=head2 FlowPDF::Types::Enum

This type is designed for pre-defined scalar values. For example, procedure context that could be one of: 'procedure', 'schedule', 'pipeline'.

%%%LANG=perl%%%

    my $enum = FlowPDF::Types::Enum('procedure', 'schedule', 'pipeline');
    my $value = 'pipeline';
    if ($enum->match($value)) {
        print "Match!\n";
    }
    else {
        print "No match: ", $arrayref->describe(), "\n";
    }

%%%LANG%%%

=head2 FlowPDF::Types::Scalar

This type represents a scalar string value. It could check that value is just scalar, or a scalar with special value.

%%%LANG=perl%%%

    my $scalar1 = FlowPDF::Types::Scalar('foo');
    my $scalar2 = FlowPDF::Types::Scalar();
    if ($scalar1->match('bar') {
        print "Match!\n"
    }
    # will no match now because scalar with exact value is expected for $scalar1 validator.
    else {
        print "No match: ", $arrayref->describe(), "\n";
    }

    # scalar2 will match any scalar, because it was created without value
    if ($scalar2->match('bar') {
        print "Match!\n"
    }

%%%LANG%%%

=head2 FlowPDF::Types::Reference

This type is for references. If you need to check object or any reference. May accept multiple references.

%%%LANG%%%

    my $ref = FlowPDF::Types::Reference('HASH', 'ElectricCommander');
    if ($ref->match({})) {
        print "Match!\n";
    }
    else {
        print "No match: ", $arrayref->describe(), "\n";
    }

%%%LANG%%%

=head2 FlowPDF::Types::Regexp

This type represents regexp and validates strings.

%%%LANG=perl%%%

    my $reg = FlowPDF::Types::Regexp(qr/^[A-Z]+$/, qr/^[a-z]+$/);
    if ($reg->match("ASDF")) {
        print "Match!\n";
    }
    else {
        print "No match: ", $arrayref->describe(), "\n";
    }

%%%LANG%%%

=cut

package FlowPDF::Types;
use strict;
use warnings;
use Data::Dumper;

use FlowPDF::Helpers qw/bailOut/;

use FlowPDF::Types::Any;
use FlowPDF::Types::Reference;
use FlowPDF::Types::Scalar;
use FlowPDF::Types::Enum;
use FlowPDF::Types::ArrayrefOf;
use FlowPDF::Types::Regexp;

sub Reference {
    my (@refs) = @_;

    return FlowPDF::Types::Reference->new(@refs);
}

sub Enum {
    my (@vals) = @_;

    return FlowPDF::Types::Enum->new(@vals);
}

sub Scalar {
    my ($value) = @_;
    return FlowPDF::Types::Scalar->new($value);
}

sub Any {
    return FlowPDF::Types::Any->new();
}

sub ArrayrefOf {
    my (@refs) = @_;

    return FlowPDF::Types::ArrayrefOf->new(@refs);
}

sub Regexp {
    my (@refs) = @_;

    return FlowPDF::Types::Regexp->new(@refs);
}

1;
