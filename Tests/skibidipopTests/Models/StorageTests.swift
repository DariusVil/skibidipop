import XCTest
@testable import skibidipop

final class StorageTests: XCTestCase {

    func testInject_whenPassingNewRepository_thenRepositoryIsAppended() {
        var sut = Storage.build(repositories: [])

        sut.inject(Repository.build(name: "HelloWorld"))

        XCTAssertEqual(sut.repositories[0].name, "HelloWorld")
    }

    func testInject_whenPassingExistingRepository_thenRepositoryIsReplaced() {
        var sut = Storage.build(repositories: [.build(chains: [.build()], name: "Game")])

        sut.inject(.build(chains: [.build(), .build()], name: "Game"))

        XCTAssertEqual(sut.repositories.count, 1)
        XCTAssertEqual(sut.repositories[0].chains.count, 2)
    }
}
