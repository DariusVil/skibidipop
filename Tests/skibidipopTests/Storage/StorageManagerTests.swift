import XCTest
@testable import skibidipop

final class StorageManagerTests: XCTestCase {

    func testAppend_whenCurrentBranchIsNotInAnyChain_shouldCreateNewChainAndAddNewBranchToIt() {
        let sut =  StorageManager()

        let repository = Repository.build(chains: [], name: "repo")
        let result = sut.append(Branch(name: "new-branch"), onto: Branch(name: "old-branch"), into: repository)

        XCTAssertEqual(result.chains[0].branches[0].name, "new-branch")
    }

    func testAppend_whenCurrentBrancIsInchain_shouldAppendNewBranchToThatChain() {
        let sut = StorageManager()

        let repository = Repository.build(
            chains: [
                .build(
                    branches: [
                        .build(name: "refactor1")
                    ]
                ),
                .build(
                    branches: [
                        .build(name: "redesign")
                    ]
                )
            ],
            name: "repo"
        )
        let result = sut.append(Branch(name: "new-branch"), onto: Branch(name: "redesign"), into: repository)

        XCTAssertEqual(result.chains[1].branches[1].name, "new-branch")
    }
}
