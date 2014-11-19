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