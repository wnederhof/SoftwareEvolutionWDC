module SIGModelCalculator

import metrics::VolumeMetric;
import metrics::DuplicationMetric;
import Prelude;
import lang::java::jdt::m3::Core;

public void calculateSigModel(loc project) {
	model = createM3FromEclipseProject(project);
	//vol = calculateVolume(model);
	//println("Volume: <vol>");
	
	dups = calculateDuplications(model);
	println("Duplications: <dups>");
}