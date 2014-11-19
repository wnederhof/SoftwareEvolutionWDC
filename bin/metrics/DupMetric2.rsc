module metrics::DupMetric2

import lang::java::jdt::m3::Core;
import IO;
import tools::FilesFetcher;

private int countDuplicates(list[str] fileContents) {
	for (fSrc <- fileContents) {
		for (l <- split("\n", fSrc)) {
			conts = findContains(fileContents, l);
		}
	}
}

public void calcDups2(M3 model) {
	list[loc] files = findCompilationUnits(model);
	list[str] fileContents;
	for (f <- files) {
		fileContents += readFile(f);
	}
	return countDuplicates(fileContents);
}