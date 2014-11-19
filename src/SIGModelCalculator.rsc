module SIGModelCalculator

import metrics::VolumeMetric;
import Prelude;
import lang::java::jdt::m3::Core;

public void calculateSigModel(loc project) {
	model = createM3FromEclipseProject(project);
	vol = calculateVolume(model);
	println("Volume: <vol>");
}