import XCTest
@testable import skibidipop

final class TextFormatterTests: XCTestCase {

    func testFormat_whenChainHasNoBranches_returnsEmptyString() {
        let sut = skibidipop.TextFormatter()

        let result = sut.format(.build(branches: []), selectedBranch: .build())

        XCTAssertEqual(result, "")
    }

    func testFormat_whenChainSeveralBranches_returnsFormattedString() {
        let sut = skibidipop.TextFormatter()

        let result = sut.format(
            .build(
                branches: [
                    .build(name: "branch1"),
                    .build(name: "branch2"),
                    .build(name: "branch3"),
                ]
            ),
            selectedBranch: .build(name: "branch2")
        )

        XCTAssertEqual(result, "branch1\nbranch2<-\nbranch3")
    }
}
