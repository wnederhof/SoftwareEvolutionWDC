module metrics::UnitTestingMetric

import lang::java::jdt::m3::Core;
import lang::java::m3::AST;
import tools::Utils;
import IO;
import String;
import Prelude;

private int calcAssertStatements(Statement impl) {
	assertStatements = 0;
	visit (impl) {
		case \assert(Expression e1):
			assertStatements += 1;
		case \assert(Expression e1, Expression e2):
			assertStatements += 1;
	}
	return assertStatements;
}

private int calcClassAssertStatements(loc methodClass) {
	Declaration classAST = createAstFromFile(methodClass, true);
	assertStatements = 0;
	/* first, let us list all methods. */
	visit (classAST) {
		case \method(Type \return, str name, list[Declaration] parameters, list[Expression] exceptions, Statement impl):
				assertStatements += calcAssertStatements(impl);
	}
	return assertStatements;
}

public num calculateUnitTesting(M3 model){
	compilationUnits = findCompilationUnits(model);
	
	return sum([ calcClassAssertStatements(l) | l <- compilationUnits]);;
}

