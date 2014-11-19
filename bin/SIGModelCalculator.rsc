module SIGModelCalculator

import metrics::VolumeMetric;
import metrics::UnitTestingMetric;
import metrics::DuplicationMetric;
import metrics::UnitSizeMetric;
import metrics::UnitComplexityMetric;
import tools::MetricScales;
import Prelude;
import lang::java::jdt::m3::Core;

public void calculateSigModel(loc project) {
	model = createM3FromEclipseProject(project);

	unitTesting = calculateUnitTesting(model);
	println("Unit Testing: <unitTesting>");
	
	totalLines = sum([ size(split("\n", readFile(l[0]))) | l <- model@containment, isCompilationUnit(l[0])]);
	
	//volume
	volume = calculateVolume(model);
	volScore = metricResult(volume, 1310, 655, 665, 246);
	
	//unit size
	list[num] unitSizeRiskCategs = calculateUnitSize(model);
	unitSizeScore = metricRiskResult(unitSizeRiskCategs[1], unitSizeRiskCategs[2], unitSizeRiskCategs[3]);
	
	//unit complexity
	list[num] unitComplRiskCategs = calculateUnitComplexity(model);
	unitComplexityScore = metricRiskResult(unitComplRiskCategs[1], unitComplRiskCategs[2], unitComplRiskCategs[3]);
		
	//duplication
	duplications = 1;
	duplicationScore = "++";
	
	//analysability = avgScore([volScore, duplicationScore, unitSizeScore]);
	//changeability = avgScore([unitComplexityScore, duplicationScore]);
	analysability = "+";
	changeability = "++";
	testability = avgScore([unitComplexityScore, unitSizeScore]);
	maintainability = avgScore([analysability, changeability, testability]);
	
	println(
		"Volume:\t\t\t<volume> \t\t<volScore>
		'Unit Complexity:\t<unitComplRiskCategs[0]>%(low), <unitComplRiskCategs[1]>%(moderate), <unitComplRiskCategs[2]>%(high), <unitComplRiskCategs[3]>%(very high)\t<unitComplexityScore>
		'Unit Size:\t\t<unitSizeRiskCategs[0]>%(low), <unitSizeRiskCategs[1]>%(moderate), <unitSizeRiskCategs[2]>%(high), <unitSizeRiskCategs[3]>%(very high)\t<unitSizeScore>
		'Duplications(%):\t<duplications/totalLines*100>%\t<duplicationScore>
		'
		'Analysability:\t\t\t\t<analysability>
		'Changability:\t\t\t\t<changeability>
		'Testability:\t\t\t\t<testability>
		'Maintainability:\t\t\t<maintainability>
		");
}