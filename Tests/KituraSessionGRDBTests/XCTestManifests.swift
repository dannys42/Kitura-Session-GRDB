import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Kitura_Session_GRDBTests.allTests),
    ]
}
#endif
