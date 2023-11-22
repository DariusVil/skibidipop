import XCTest
@testable import skibidipop

final class RepositoryManagerTests: XCTestCase {

    // MARK: - append 

    func testAppend_whenCurrentBranchIsNotInAnyChain_shouldCreateNewChainAndAddNewBranchToIt() {
        let sut =  RepositoryManager()

        let repository = Repository.build(chains: [], name: "repo")
        let result = sut.append(Branch(name: "new-branch"), onto: Branch(name: "old-branch"), into: repository)

        XCTAssertEqual(result.chains[0].branches[0].name, "new-branch")
    }

    func testAppend_whenCurrentBrancIsInchain_shouldAppendNewBranchToThatChain() {
        let sut = RepositoryManager()

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

    // MARK - chain

    func testChain_whenRepositoryHasNoSuchBranch_returnsNil() {
        let sut = RepositoryManager()
        let repository = Repository.build(chains: [])
        let branch = Branch.build(name: "master")

        let chain = sut.chain(in: repository, with: branch)

        XCTAssertNil(chain)
    }

    func testChain_whenRepositoryContainsBranch_returnsThatBranch() {
        let sut = RepositoryManager()

        let chain = Chain.build(branches: [.build(name: "feature1"), .build(name: "feature2")])
        let repository = Repository.build(
            chains: [
                .build(branches: [.build(name: "master"), .build(name: "develop")]),
                chain 
            ]
        )
        let branch = Branch.build(name: "feature1")

        let result = sut.chain(in: repository, with: branch)

        XCTAssertEqual(result, chain)
    }
}
