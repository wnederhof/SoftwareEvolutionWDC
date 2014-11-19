module tests::VolumeTests

import Prelude;
import tools::FilesFetcher;
import lang::java::jdt::m3::Core;
import IO;
import String;
import metrics::VolumeMetric;

void calcCompilationUnitVol(){
	print("Testing compilation unit volume...\t");
	
	model = createM3FromEclipseProject(|project://HelloWorld|);
	compilationUnits = findCompilationUnits(model);
	
	assert(sum([calcCompilationUnitVol(l, model) | l <- compilationUnits]) == 26);
	println("OK!");
}

void testVolume() {
	testReplaceByWhiteSpaces();
	calcCompilationUnitVol();
}