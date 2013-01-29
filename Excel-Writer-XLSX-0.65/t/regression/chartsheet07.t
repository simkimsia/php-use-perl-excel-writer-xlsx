###############################################################################
#
# Tests the output of Excel::Writer::XLSX against Excel generated files.
#
# reverse ('(c)'), January 2011, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_compare_xlsx_files _is_deep_diff);
use strict;
use warnings;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $filename     = 'chartsheet07.xlsx';
my $dir          = 't/regression/';
my $got_filename = $dir . $filename;
my $exp_filename = $dir . 'xlsx_files/' . $filename;

my $ignore_members = [
    qw(
      xl/printerSettings/printerSettings1.bin
      xl/chartsheets/_rels/sheet1.xml.rels
      )
];


my $ignore_elements = {
    '[Content_Types].xml'       => ['<Default Extension="bin"'],
    'xl/workbook.xml'           => ['<workbookView'],

    'xl/chartsheets/sheet1.xml' => [
        '<pageSetup',
        '<drawing',    # Id is wrong due to missing printerbin.
      ],
};


###############################################################################
#
# Test the worksheet properties of an Excel::Writer::XLSX chartsheet file.
#
use Excel::Writer::XLSX;

my $workbook  = Excel::Writer::XLSX->new( $got_filename );
my $worksheet = $workbook->add_worksheet();
my $chart     = $workbook->add_chart( type => 'bar' );

# For testing, copy the randomly generated axis ids in the target xlsx file.
$chart->{_chart}->{_axis_ids} = [ 43911040, 46363392 ];

my $data = [
    [ 1, 2, 3, 4,  5 ],
    [ 2, 4, 6, 8,  10 ],
    [ 3, 6, 9, 12, 15 ],

];

$worksheet->write( 'A1', $data );

$chart->add_series( values => '=Sheet1!$A$1:$A$5' );
$chart->add_series( values => '=Sheet1!$B$1:$B$5' );
$chart->add_series( values => '=Sheet1!$C$1:$C$5' );

# Chartsheet test.
$chart->set_paper( 9 );
$chart->set_portrait();

$workbook->close();


###############################################################################
#
# Compare the generated and existing Excel files.
#

my ( $got, $expected, $caption ) = _compare_xlsx_files(

    $got_filename,
    $exp_filename,
    $ignore_members,
    $ignore_elements,
);

_is_deep_diff( $got, $expected, $caption );


###############################################################################
#
# Cleanup.
#
unlink $got_filename;

__END__



