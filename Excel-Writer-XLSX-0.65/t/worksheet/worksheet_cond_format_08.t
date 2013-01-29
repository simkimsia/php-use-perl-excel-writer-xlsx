###############################################################################
#
# Tests for Excel::Writer::XLSX::Worksheet methods.
#
# reverse ('(c)'), October 2011, John McNamara, jmcnamara@cpan.org
#

use lib 't/lib';
use TestFunctions qw(_expected_to_aref _got_to_aref _is_deep_diff _new_worksheet);
use strict;
use warnings;

use Test::More tests => 1;

###############################################################################
#
# Tests setup.
#
my $expected;
my $got;
my $caption;
my $worksheet;


###############################################################################
#
# Test the _assemble_xml_file() method.
#
# Test conditional formats.
#
$caption = " \tWorksheet: _assemble_xml_file()";

$worksheet = _new_worksheet(\$got);

$worksheet->select();

# Start test code.
$worksheet->write( 'A1', 10 );
$worksheet->write( 'A2', 20 );
$worksheet->write( 'A3', 30 );
$worksheet->write( 'A4', 40 );

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'yesterday',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'today',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'tomorrow',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'last 7 days',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'last week',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'this week',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'next week',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'last month',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'this month',
        format   => undef,
    }
);

$worksheet->conditional_formatting( 'A1:A4',
    {
        type     => 'time_period',
        criteria => 'next month',
        format   => undef,
    }
);

# End test code.

$worksheet->_assemble_xml_file();

$expected = _expected_to_aref();
$got      = _got_to_aref( $got );

_is_deep_diff( $got, $expected, $caption );

__DATA__
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <dimension ref="A1:A4"/>
  <sheetViews>
    <sheetView tabSelected="1" workbookViewId="0"/>
  </sheetViews>
  <sheetFormatPr defaultRowHeight="15"/>
  <sheetData>
    <row r="1" spans="1:1">
      <c r="A1">
        <v>10</v>
      </c>
    </row>
    <row r="2" spans="1:1">
      <c r="A2">
        <v>20</v>
      </c>
    </row>
    <row r="3" spans="1:1">
      <c r="A3">
        <v>30</v>
      </c>
    </row>
    <row r="4" spans="1:1">
      <c r="A4">
        <v>40</v>
      </c>
    </row>
  </sheetData>
  <conditionalFormatting sqref="A1:A4">
    <cfRule type="timePeriod" priority="1" timePeriod="yesterday">
      <formula>FLOOR(A1,1)=TODAY()-1</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="2" timePeriod="today">
      <formula>FLOOR(A1,1)=TODAY()</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="3" timePeriod="tomorrow">
      <formula>FLOOR(A1,1)=TODAY()+1</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="4" timePeriod="last7Days">
      <formula>AND(TODAY()-FLOOR(A1,1)&lt;=6,FLOOR(A1,1)&lt;=TODAY())</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="5" timePeriod="lastWeek">
      <formula>AND(TODAY()-ROUNDDOWN(A1,0)&gt;=(WEEKDAY(TODAY())),TODAY()-ROUNDDOWN(A1,0)&lt;(WEEKDAY(TODAY())+7))</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="6" timePeriod="thisWeek">
      <formula>AND(TODAY()-ROUNDDOWN(A1,0)&lt;=WEEKDAY(TODAY())-1,ROUNDDOWN(A1,0)-TODAY()&lt;=7-WEEKDAY(TODAY()))</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="7" timePeriod="nextWeek">
      <formula>AND(ROUNDDOWN(A1,0)-TODAY()&gt;(7-WEEKDAY(TODAY())),ROUNDDOWN(A1,0)-TODAY()&lt;(15-WEEKDAY(TODAY())))</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="8" timePeriod="lastMonth">
      <formula>AND(MONTH(A1)=MONTH(TODAY())-1,OR(YEAR(A1)=YEAR(TODAY()),AND(MONTH(A1)=1,YEAR(A1)=YEAR(TODAY())-1)))</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="9" timePeriod="thisMonth">
      <formula>AND(MONTH(A1)=MONTH(TODAY()),YEAR(A1)=YEAR(TODAY()))</formula>
    </cfRule>
    <cfRule type="timePeriod" priority="10" timePeriod="nextMonth">
      <formula>AND(MONTH(A1)=MONTH(TODAY())+1,OR(YEAR(A1)=YEAR(TODAY()),AND(MONTH(A1)=12,YEAR(A1)=YEAR(TODAY())+1)))</formula>
    </cfRule>
  </conditionalFormatting>
  <pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>
</worksheet>
