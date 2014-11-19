module tests::MetricScalesTests

import IO;

import tools::MetricScales;

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

/* The tests are based on fig. 5. */
void testAvgScore() {
	print("Testing avgScore,intToScore...\t");
	assert(avgScore(["++", "-", "-", "o"]) == "o");
	assert(avgScore(["--", "-"]) == "-");
	assert(avgScore(["o"]) == "o");
	assert(avgScore(["--", "-", "o"]) == "-");
	println("OK!");
}


void testmetricRiskResult(){
	print("Testing testmetricRiskResult...\t");
	assert(metricRiskResult(25,0,0) == "++");
	assert(metricRiskResult(30,5,0) == "+");
	assert(metricRiskResult(40,10,0) == "o");
	assert(metricRiskResult(50,15,5) == "-");
	assert(metricRiskResult(51,16,6) == "--");
	println("OK!");

}

void testMetricScales() {
	testMetricResult();
	testScoreToInt();
	testAvgScore();
	testmetricRiskResult();
}