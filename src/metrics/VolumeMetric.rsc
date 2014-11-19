module metrics::VolumeMetric

import lang::java::jdt::m3::Core;
import tools::Utils;
import IO;
import String;
import Prelude;

public int calcCompilationUnitVol(loc l, M3 model) {
	str s = readFile(l);
	set[loc] locs = findDocForCompilationUnit(l, model);
	for (l2 <- locs) {
		s = replaceByWhiteSpaces (s, l2.offset, l2.length);
	}
	linesOfCode = size([lineOfCode | lineOfCode <- split("\n", s), size(trim(lineOfCode)) != 0]);
	return linesOfCode;
}
 
public num calculateVolume(M3 model) {
	compilationUnits = findCompilationUnits(model);
	return sum([calcCompilationUnitVol(l, model) | l <- compilationUnits]);
}