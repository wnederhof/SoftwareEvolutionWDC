module tests::UtilsTests

import IO;
import String;

import tools::Utils;

void testReplaceByWhiteSpaces() {
	print("Testing ReplaceByWhiteSpaces...\t");
	str testStr = "abcdefg";
	assert(replaceByWhiteSpaces(testStr,1,3) == "a   efg");
	println("OK!");
}