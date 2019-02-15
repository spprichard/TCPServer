import XCTest

import TCPServerTests

var tests = [XCTestCaseEntry]()
tests += TCPServerTests.allTests()
XCTMain(tests)