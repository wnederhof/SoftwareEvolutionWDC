module SIGModelCalculator

import metrics::VolumeMetric;
import metrics::UnitTestingMetric;
import metrics::DuplicationMetric;
import Prelude;
import lang::java::jdt::m3::Core;

//|project://smallsql0.21_src|
//|project://hsqldb-2.3.1|
public void calculateSigModel(loc project) {
	model = createM3FromEclipseProject(project);
	vol = calculateVolume(model);
	unitTesting = calculateUnitTesting(model);
	println("Volume: <vol>");
	println("Unit Testing: <unitTesting>");
	//vol = calculateVolume(model);
	//println("Volume: <vol>");
	
	dups = calculateDuplications(model);
	println("Duplications: <dups>");
}