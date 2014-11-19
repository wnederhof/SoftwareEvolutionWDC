module metrics::VolumeMetric

import lang::java::jdt::m3::Core;
import tools::FilesFetcher;
import IO;
import String;
import Prelude;

/**
 * Replace the offset until length by whitespaces.
 */
private str replaceByWhiteSpaces (str s, int offset, int length) {
	str sN = substring (s, 0, offset);
	for (i <- [0..length])
		sN += " ";
	return sN + substring (s, offset + length); 
}

/**
 * Calculate the compilation units volumes.
 */
private int calcCompilationUnitVol(loc l, M3 model) {
	str s = readFile(l);
	set[loc] locs = findDocForCompilationUnit(l, model);
	for (l2 <- locs) {
		s = replaceByWhiteSpaces (s, l2.offset, l2.length);
	}
	linesOfCode = size([lineOfCode | lineOfCode <- split("\n", s), size(trim(lineOfCode)) != 0]);
	return linesOfCode;
}

/**
 * Calculate the volume of the project.
 */
public num calculateVolume(M3 model) {
	compilationUnits = findCompilationUnits(model);
	return sum([calcCompilationUnitVol(l, model) | l <- compilationUnits]);
}