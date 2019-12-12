import XCTest

import IntcodeTests

var tests = [XCTestCaseEntry]()
tests += IntcodeTests.allTests()
XCTMain(tests)
