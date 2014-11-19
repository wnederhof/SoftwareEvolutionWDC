module tools::MetricScales

import Prelude;

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

str metricRiskResult(moderate, high, veryHigh) {
	if(moderate <= 25 && high == 0 && veryHigh == 0)
		return "++";
	if(moderate <= 30 && high <= 5 && veryHigh == 0)
		return "+";
	if(moderate <= 40 && high <= 10 && veryHigh == 0)
		return "o";
	if(moderate <= 50 && high <= 15 && veryHigh <= 5)
		return "-";
	return "--";
}