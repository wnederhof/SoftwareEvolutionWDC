module Week1

import Prelude;
import util::Math;
import IO;
import String;
import lang::java::m3::AST;
import lang::java::jdt::m3::Core;

/**
 * DONE:
 *
 * - The metric value (total LOC) and/or score for Volume deviate
 * - The metric value (%) and/or score for Duplication deviate
 * - The scores calculated for the maintainability aspects deviate (TODO NEEDS TESTING!!)
 */
str joinStrs(list[str] strs, str joiner) {
	if (size(strs) == 0) return "";
	if (size(strs) == 1) return head(strs);
	return head(strs) + joiner + joinStrs(tail(strs), joiner);
}

/** ltrim, because the document states only left trimming. */
str ltrim(str s) {return s == ""?"":
	(((substring(s, 0, 1) == " ")
 || (substring(s, 0, 1) == "\t")) ? ltrim(substring(s, 1)) : s);}

// Yes, I know, the hack here is aweful. Could not find an easier solution in the documentation...
bool hasKey(m, str key) {
	try {
		m[key] = m[key];
		return true;
	} catch:
		return false;
}

map[str, set[tuple[str, int]]] calcCodeMap(loc l, map[str, set[tuple[str, int]]] orig) {
	list[str] fileContent = [ltrim(s)|s<-split("\n", readFile(l))];
	int lines = size(fileContent);
	if (lines >= 6) {
		for (int iOff <- [0..(lines-6)],int iLen <- [6..lines-iOff+1]) {
			lns = fileContent[iOff..iLen+iOff];
			str s = joinStrs(lns, "\n");
			if (!hasKey(orig, s)) {
				orig[s] = {};
			}
			for (int i <- [0..iLen]) {
				orig[s] += {<l.uri, iOff>}; 
			}
		}
	}
	return orig;
}



/** This function replaces s from offset to offset+length with whitespaces. */
str replByWhiteSpaces (str s, int offset, int length) {
	str sN = substring (s, 0, offset);
	for (i <- [0..length])
		sN += " ";
	return sN + substring (s, offset + length); 
}

/**
 * Calculate the size of a block by it's LOC sans comments and blank lines.
 * Not only supports entire files, but also partial files.
 */
// NOTE, when calculating the unit size, it also counts the method header and footer!
int calcBlockSize (loc l, M3 model) {
	int offset;
	try {
		offset = l.offset;
	} catch UnavailableInformation():
		offset = 0;
	str file = readFile(l);
	
	// function does not work for units because of the d[0] == ...
	for (d <- [<d[1].offset, d[1].length> | d <- model@documentation, (d[1].uri == l.uri || d[0].uri == l.uri)]) {
		try {
			file = replByWhiteSpaces(file, d[0] - offset, d[1]);
		} catch: // let's just do this the easy way :-)
			continue;
	}
	return size([li | str li <- split("\n", file), (trim(li) != "")]);
}

int calcUnitComplexity(Statement impl) {
	int result = 1;
	visit (impl) {
		case \do(_,_): result += 1;
		case \while(_,_): result += 1;
		case \if(_,_): result += 1;
		case \if(_,_,_): result += 1;
		case \for(_,_,_,_): result += 1;
		case \for(_,_,_): result += 1;
		case \foreach(_,_,_): result += 1;
		case \switch(_,_): result += 1;
		case \catch(_,_): result += 1;
	}
	return result;
}

list[int] calcClassComplexities (loc methodClass) {
	Declaration classAST = createAstFromFile(methodClass, true);
	list[int] unitComplexities = [];
	/* first, let us list all methods. */
	visit (classAST) {
		case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl):
			unitComplexities += calcUnitComplexity(impl);
	}
	return unitComplexities;
}

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

num calcLOCDuplications(list[loc] locs) {
	codeMap = ();
	/* Here we create a hashmap of each block of code. */
	for (l <- locs) {
		codeMap = calcCodeMap(l, codeMap);
	}
	return sum([ size(codeMap[l]) | l <- codeMap, size(codeMap[l]) > 1 ]);
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

int calcAssertStatements(Statement impl) {
	assertStatements = 0;
	visit (classAST) {
		case \assert(Expression e1):
			assertStatements += 1;
		case \assert(Expression e1, Expression e2):
			assertStatements += 1;
	}
	return unitComplexities;
}

int calcClassAssertStatements(loc methodClass) {
	Declaration classAST = createAstFromFile(methodClass, true);
	assertStatements = 0;
	/* first, let us list all methods. */
	visit (classAST) {
		case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl):
			assertStatements += calcAssertStatements(impl);
	}
	return assertStatements;
}

void main () {
	project = |project://HelloWorld|;
	model = createM3FromEclipseProject(project);
	totalLOCs = sum([ calcBlockSize(l[0], model) | l <- model@containment, isCompilationUnit(l[0])]);
	totalLines = sum([ size(split("\n", readFile(l[0]))) | l <- model@containment, isCompilationUnit(l[0])]);
	unitLOCs = [ calcBlockSize(l[1], model) | l <- model@declarations, isMethod(l[0])];
	unitClassCompls = [ calcClassComplexities(l[0]) | l <- model@containment, isCompilationUnit(l[0])];
	classAssertStmts = [ calcClassAssertStatements(l[0]) | l <- model@containment, isCompilationUnit(l[0])];
	
	
	avgUnitCompl = avg([ avg(ucc) | ucc <- unitClassCompls ]);
	avgUnitLOCs = avg(unitLOCs);
	duplications = calcLOCDuplications([l[0] | l <- model@containment, isCompilationUnit(l[0])]);
	unitTests = calcAssertStatements();
	unitTestsPct = unitTests / totalLOCs;
	
	volScore = metricResult(totalLOCs, 1310, 655, 665, 246);
	unitComplexityScore = metricResult(avgUnitCompl, 50, 20, 10, 5);
	unitSizeScore = metricResult(avgUnitLOCs, 100, 50, 20, 10); // TODO THESE SCORES NEED TO BE CHECKED!!
	duplicationScore = metricResult(duplications/totalLines*100, 20, 10, 5, 3);
	unitTestingScore = metricResult(1-unitTestsPct,.995,.99,.98,.97,.95);
	
	analysability = avgScore([volScore, duplicationScore, unitSizeScore]);
	stability = unitTestingScore;
	changeability = avgScore([unitComplexityScore, duplicationScore]);
	testability = avgScore([unitComplexityScore, unitSizeScore]);
	maintainability = avgScore([analysability, changeability, testability]);
	
	// TODO AVG. UNIT COMPLEXITY AND - SIZE HAVE TO BE UPDATED ACCORDING TO THE RISK THING!!
	println(
		"Volume:\t\t\t<totalLOCs> (<totalLines>)\t\t<volScore>
		'Avg. Unit Complexity:\t<avgUnitCompl>\t<unitComplexityScore>
		'Avg. Unit Size:\t\t<avgUnitLOCs>\t\t<unitSizeScore>
		'Unit Testing:\t\t<unitTestsPct>\t\t<unitTestingScore>
		'Duplications(%):\t<duplications/totalLines*100>%\t<duplicationScore>
		'
		'Analysability:\t\t\t\t<analysability>
		'Stability:\t\t\t\t<stability>
		'Changability:\t\t\t\t<changeability>
		'Testability:\t\t\t\t<testability>
		'Maintainability:\t\t\t<maintainability>
		");
}