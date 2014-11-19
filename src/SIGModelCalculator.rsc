module SIGModelCalculator

import metrics::VolumeMetric;
import metrics::DuplicationMetric;
import metrics::UnitSizeMetric;
import metrics::UnitComplexityMetric;
import Prelude;
import lang::java::jdt::m3::Core;

str metricResult(val, veryBad, bad, medium, good) {
	if (val > veryBad)
		return "--";
	if (val > bad)
		return "-";
	if (val > medium)
		return "o";
	if (val > good)
		return "+";
	return "++";
}

str metricRiskResult(moderate, high, veryHigh) {
	if(moderate <= 25 && high == 0 && veryHigh == 0)
		return "++";
	if(moderate <= 30 && high <= 5 && veryHigh == 0)
		return "+";
	if(moderate <= 40 && high <= 10 && veryHigh == 0)
		return "o";
	if(moderate <= 50 && high <= 15 && veryHigh <= 5)
		return "-";
	return "--";
}

num avg(x) { return sum(x) / size(x); }

int scoreToInt(str s) {
	if (s == "++") return 5;
	if (s == "+") return 4;
	if (s == "o") return 3;
	if (s == "-") return 2;
	if (s == "--") return 1;
}

// TODO this needs to be tested using fig. 5.
str intToScore(num i) {
	if (i >= 4.5) return "++";
	if (i >= 3.5) return "+";
	if (i >= 2.5) return "o";
	if (i >= 1.5) return "-";
	return "--";
}

str avgScore (list[str] scores) {
	return intToScore(avg([scoreToInt(s) | s <- scores]));
}

public void calculateSigModel(loc project) {
	model = createM3FromEclipseProject(project);

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