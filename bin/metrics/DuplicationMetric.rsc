module metrics::DuplicationMetric

import lang::java::jdt::m3::Core;
import tools::FilesFetcher;
import String;
import List;
import IO;

/**
 * Join the specified list of strings using the joiner as glue.
 */
private str joinStrings(list[str] strs, str joiner) {
	if (size(strs) == 0) return "";
	if (size(strs) == 1) return head(strs);
	return head(strs) + joiner + joinStrings(tail(strs), joiner);
}


/**
 * A hack in order to see if a map has the requested key.
 */
private bool hasKey(m, str key) {
	try {
		m[key] = m[key];
		return true;
	} catch:
		return false;
}

/**
 * Trim all lines in a list.
 */
private list[str] trimAll(list[str] strs) {
	list[str] res = [];
	for (s <- strs) {
		res += trim(s);
	}
	return res;
}

/**
 * Calculate the duplications in the provided list of files, by creating a hashmap from code block to
 * a list of references, and returning each block for which the references count are higher than 2.
 */
private num calcFilesDuplications(set[loc] locs) {
	map [str, set[tuple[loc,int,int]]] codemap = ();
	for (l <- locs) {
		println("LOC: <l>");
		list[str] file = split("\n", readFile(l));
		lines = size(file);
		
		if (lines >= 6) {
			curr = "";
			for (int iOff <- [0..(lines-6)],int iLen <- [6..lines-iOff]) {
				if (iLen == 6) { 
					curr = joinStrings(trimAll(file[iOff..iLen]), "\n");
				}
				curr += "\n" + file[iOff+iLen];
				// println("<iOff>, <iLen>");
				s = curr;
				if (!hasKey(codemap, s)) codemap[s] = {}; 
				codemap[s] += {<l, iOff, iLen>};
			}
		}
	}
	set[tuple[loc,int]] codeLocs = {};
	for (str cbId <- codemap) {
		codeBlock = codemap[cbId];
		if (size([x|x<-codeBlock]) > 1) {
			for (codeLocation <- codeBlock) {
				for (int i <- [codeLocation[1]..(codeLocation[1]+codeLocation[2])]) {
					codeLocs += <codeLocation[0], i>;
				}
			}
		}
	}
	println(codeLocs);
	return size([x|x<-codeLocs]);
}

/**
 * Calculate the duplications in the compilation units in the model.
 */
public num calculateDuplications(M3 model) {
	return calcFilesDuplications(findCompilationUnits(model));
}