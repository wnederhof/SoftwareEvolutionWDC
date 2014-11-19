module tools::Utils

import lang::java::jdt::m3::Core;
import IO;
import String;
import Prelude;

public set[loc] findCompilationUnits(M3 model) {
	return {l[0] | l <- model@containment, isCompilationUnit(l[0])};
}

public set[loc] findDocForCompilationUnit(loc cu, M3 model) {
	return {l[1] | l <- model@documentation, l[0].path == cu.path || l[1].path == cu.path};
}

public str replaceByWhiteSpaces (str s, int offset, int length) {
	str sN = substring (s, 0, offset);
	for (i <- [0..length])
		sN += " ";
	return sN + substring (s, offset + length); 
}