module tools::FilesFetcher

import Prelude;
import lang::java::jdt::m3::Core;

public set[loc] findCompilationUnits(M3 model) {
	return {l[0] | l <- model@containment, isCompilationUnit(l[0])};
}

public set[loc] findDocForCompilationUnit(loc cu, M3 model) {
	return {l[1] | l <- model@documentation, l[0].path == cu.path || l[1].path == cu.path};
}