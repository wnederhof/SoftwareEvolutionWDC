module Week1Tests

import Week1;
import Prelude;

void testJoinStrs() {
	print("Testing joinStrs...\t\t");
	assert(joinStrs(["a","b","c"], "d") == "adbdc");
	assert(joinStrs([""], "d") == "");
	assert(joinStrs(["a"], "d") == "a");
	println("OK!");
}

void testLtrim() {
	print("Testing ltrim...\t\t");
	assert(ltrim("") == "");
	assert(ltrim(" ") == "");
	assert(ltrim(" \tabc\t ") == "abc\t ");
	println("OK!");
}

void testHasKey() {
	print("Testing hasKey...\t\t");
	myMap = ("a": "b"); 
	assert(hasKey(myMap, "a"));
	assert(!hasKey(myMap, "b"));
	println("OK!");
}

void testCalcCodeMap() {
	print("Testing calcCodeMap...\t\t");
	// TODO ...
	println("NOT IMPLEMENTED!");
}

void testReplByWhiteSpaces() {
	print("Testing replByWhiteSpaces...\t");
	str testStr = "abcdefg";
	assert(replByWhiteSpaces(testStr,1,3) == "a   efg");
	println("OK!");
}

void testCalcBlockSize() {
	print("Testing calcBlockSize...\t");
	// TODO ...
	println("NOT IMPLEMENTED!");
}

void testCalcUnitComplexity() {
	print("Testing calcUnitComplexity...\t");
	// TODO ...
	println("NOT IMPLEMENTED!");
}

void testCalcClassComplexities() {
	print("Testing calcClassComplexities...");
	// TODO ...
	println("NOT IMPLEMENTED!");
}

void testMetricResult() {
	print("Testing metricResult...\t\t");
	assert(metricResult(0, 40, 30, 20, 10) == "++");
	assert(metricResult(10, 40, 30, 20, 10) == "++");
	assert(metricResult(20, 40, 30, 20, 10) == "+");
	assert(metricResult(30, 40, 30, 20, 10) == "o");
	assert(metricResult(40, 40, 30, 20, 10) == "-");
	assert(metricResult(50, 40, 30, 20, 10) == "--");
	println("OK!");
}

void testScoreToInt() {
	print("Testing scoreToInt...\t\t");
	assert(scoreToInt("++") == 5);
	assert(scoreToInt("+") == 4);
	assert(scoreToInt("o") == 3);
	assert(scoreToInt("-") == 2);
	assert(scoreToInt("--") == 1);
	println("OK!");
}

void testCalcLOCDuplications() {
	print("Testing calcLOCDuplications...\t");
	// TODO ...
	println("NOT IMPLEMENTED!");
}

/* The tests are based on fig. 5. */
void testAvgScore() {
	print("Testing avgScore,intToScore...\t");
	assert(avgScore(["++", "-", "-", "o"]) == "o");
	assert(avgScore(["--", "-"]) == "-");
	assert(avgScore(["o"]) == "o");
	assert(avgScore(["--", "-", "o"]) == "-");
	println("OK!");
}

void testWeek1() {
	testJoinStrs();
	testLtrim();
	testHasKey();
	testCalcCodeMap();
	testReplByWhiteSpaces();
	testCalcBlockSize();
	testCalcUnitComplexity();
	testCalcClassComplexities();
	testMetricResult();
	testScoreToInt();
	testCalcLOCDuplications();
	testAvgScore();
}

void maintainabilityWeek1() {
	project = [|rascal://RascalAss1/Week1.rsc|, |rascal://RascalAss1/Week1Tests.rsc|];
	println("calculating duplications...");
	duplications = calcLOCDuplications(project);
	println(duplications);
}