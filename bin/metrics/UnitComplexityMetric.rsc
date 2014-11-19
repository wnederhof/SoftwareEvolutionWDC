module metrics::UnitComplexityMetric

import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import tools::Utils;
import IO;
import String;
import Prelude;

public int calcUnitSizeForCompl (loc l, int offset, int length, M3 model) {
	str file = readFile(l);
	
	// function does not work for units because of the d[0] == ...
	for (d <- [<doc[1].offset, doc[1].length> | doc <- model@documentation, (doc[1].path == l.path || doc[0].path == l.path)]) {
		try {
			file = replaceByWhiteSpaces(file, d[0], d[1]);
		} catch:
			continue;
	}
	file = substring(file,offset,offset+length);
	return size([li | str li <- split("\n", file), size(trim(li)) != 0]);
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
		case \case(_): result+=1;
		case \catch(_,_): result += 1;
	}
	return result;
}

list[tuple[int,int]] calcClassComplexities (loc methodClass, M3 model) {
	Declaration classAST = createAstFromFile(methodClass, true);
	list[tuple[int,int]] unitComplexities = [];
	visit (classAST) {
		case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl):
			{
			unitSize = calcUnitSizeForCompl(methodClass, impl@src.offset, impl@src.length, model);
			unitComplexity = calcUnitComplexity(impl);
			unitComplexities += <unitSize, unitComplexity>;
			}			
	}
	return unitComplexities;
}


public list[num] calculateUnitComplexity(M3 model) {
	list[num] unitComplRiskCategs = [];
	unitClassCompls = [ calcClassComplexities(l[0],model) | l <- model@containment, isCompilationUnit(l[0])];
	
	totalUnitLOCs = sum([u[0] | c <- unitClassCompls, u <-c]);
	unitComplRiskCategs += sum([u[0] | c <- unitClassCompls, u <- c, u[1] <= 10 ])/totalUnitLOCs*100;
	unitComplRiskCategs += sum([u[0] | c <- unitClassCompls, u <- c, u[1] > 10 && u[1] <= 20])/totalUnitLOCs*100;
	unitComplRiskCategs += sum([u[0] | c <- unitClassCompls, u <- c, u[1] > 20 && u[1] <= 50])/totalUnitLOCs*100;
	unitComplRiskCategs += sum([u[0] | c <- unitClassCompls, u <- c, u[1] > 50])/totalUnitLOCs*100;
	
	return unitComplRiskCategs;
}