module metrics::UnitSizeMetric

import lang::java::jdt::m3::Core;
import tools::Utils;
import IO;
import String;
import Prelude;

public int calcUnitSize (loc l, M3 model) {
	int offset;
	try {
		offset = l.offset;
	} catch UnavailableInformation():
		offset = 0;		
	str file = readFile(l);
	
	// function does not work for units because of the d[0] == ...
	for (d <- [<d[1].offset, d[1].length> | d <- model@documentation, (d[1].path == l.path || d[0].path == l.path)]) {
		try {
			file = replaceByWhiteSpaces(file, d[0] - offset, d[1]);
		} catch:
			continue;
	}
	return size([li | str li <- split("\n", file), size(trim(li)) != 0]);
}

public list[num] calculateUnitSize(M3 model){
	list[num] unitSizeRiskCategs = [];
	unitLOCs = [calcUnitSize(l[1], model) | l <- model@declarations, isMethod(l[0])];
	totalUnitLOC = sum(unitLOCs);
	unitSizeRiskCategs += sum([ u | u <- unitLOCs, u <= 20])/totalUnitLOC*100;
	unitSizeRiskCategs += sum([ u | u <- unitLOCs, u > 20 && u <= 50])/totalUnitLOC*100;
	unitSizeRiskCategs += sum([ u | u <- unitLOCs, u > 50 && u <= 100])/totalUnitLOC*100;
	unitSizeRiskCategs += sum([ u | u <- unitLOCs, u > 100])/totalUnitLOC*100;
	
	return unitSizeRiskCategs;	
}