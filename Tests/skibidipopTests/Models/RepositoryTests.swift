import XCTest
@testable import skibidipop

final class RepositoryTests: XCTestCase {

    func testInitFromName_shouldCreateRepositoryWithoutChains() {
        let repository = Repository(name: "todoList")

        XCTAssertEqual(
            repository,
            Repository(chains: [], name: "todoList")
        )
    }
}
