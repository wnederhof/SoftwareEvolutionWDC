module tests::Tests

import IO;
import String;

import tests::VolumeTests;
import tests::MetricScalesTests;

void testAll() {
	println("Testing Volume");
	testVolume();
	
	println("Testing Metric Scales");
	testMetricScales();
}