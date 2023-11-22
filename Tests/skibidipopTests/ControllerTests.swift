import XCTest
@testable import skibidipop

final class ControllerTests: XCTestCase {

    // MARK: - chain

    func testChain_whenNotInRepository_shouldPrintError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = nil

        fixture.sut.chain(branch: "ios/branchey")
        XCTAssertEqual(
            fixture.printerMock.printReceivedValue, 
            "Repository not found"
        )
    }

    func testChain_whenRepositoryExistsButCanGetBranch_shouldPrintError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = nil

        fixture.sut.chain(branch: "ios/branchey")
        XCTAssertEqual(
            fixture.printerMock.printReceivedValue, 
            "Cant checkout from current branch"
        )
    }

    func testChain_whenRepositoryAndBranchExists_shouldCheckoutCommitChanges() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"

        fixture.sut.chain(branch: "ios/branchey")
        XCTAssert(fixture.gitInterpreterMock.checkoutCalled)
        XCTAssert(fixture.gitInterpreterMock.addCalled)
        XCTAssert(fixture.gitInterpreterMock.commitCalled)
    }

    func testChain_whenRepositoryAndBranchExists_shouldSaveRepository() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"

        fixture.sut.chain(branch: "ios/branchey")
        XCTAssert(fixture.storageWorkerMock.saveCalled)
    }

    // MARK: - list

    func testList_givenNotOnRepository_shouldPrintAntError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = nil

        fixture.sut.list()

        XCTAssertEqual(fixture.printerMock.printReceivedValue, "Repository not found")
    }

    func testList_givenNoCurrentBranch_shouldPrintAntError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = nil

        fixture.sut.list()

        XCTAssertEqual(fixture.printerMock.printReceivedValue, "Cant find current branch")
    }

    func testList_givenCantLoadStorage_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = nil

        fixture.sut.list()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Can't load skibidibop configuration. You need to `chain` first"
        )
    }

    func testList_givenStorageIsLoaded_printsTheCurrentChain() {
        let fixture = Fixture()

        let chain = Chain.build(branches: [
                .build(name: "master"),
                .build(name: "feature-api"),
                .build(name: "feature-ui")
            ]
        )

        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "feature-api"
        fixture.repositoryManagerMock.chainReturnValue = chain
        fixture.presenterMock.formatReturnValue = "formatted result"
        fixture.storageWorkerMock.loadReturnValue = .build(
            repositories: [
                .build(
                    chains: [
                        chain
                    ],
                    name: "Repo"
                )
            ]
        )

        fixture.sut.list()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "formatted result"
        )
    }
}

private struct Fixture {

    let sut: Controller
    let gitInterpreterMock: GitInterpretingMock
    let presenterMock: PresentingMock
    let printerMock: PrintingMock
    let storageWorkerMock: StorageWorkingMock
    let repositoryManagerMock: RepositoryManagingMock

    init() {
        gitInterpreterMock = .init()
        presenterMock = .init()
        printerMock = .init()
        storageWorkerMock = .init()
        repositoryManagerMock = .init()
        sut = Controller(
            gitInterpreter: gitInterpreterMock,
            presenter: presenterMock,
            printer: printerMock,
            storageWorker: storageWorkerMock,
            repositoryManager: repositoryManagerMock
        )
    }
}

private class GitInterpretingMock: GitInterpreting {

    func initialize() {}
    func createBranch(with name: String) {}

    var checkoutCalled = false
    func checkout(into branchName: String) {
        checkoutCalled = true
    }

    func rebase(onto branch: String) {}

    var commitCalled = false
    func commit(with message: String) {
        commitCalled = true
    }

    var addCalled = false
    func add() {
        addCalled = true
    }

    var isRepositoryReturnValue = false
    var isRepository: Bool { isRepositoryReturnValue }

    var branchesReturnValue: [String] = [] 
    var branches: [String] { branchesReturnValue }

    var currentBranchReturnValue: String? = nil
    var currentBranch: String? { currentBranchReturnValue }

    var repositoryNameReturnValue: String? = nil
    var repositoryName: String? { repositoryNameReturnValue }
}

private class PresentingMock: Presenting {

    var formatReturnValue: String = ""
    func format(_ chain: Chain, selectedBranch: Branch) -> String {
        formatReturnValue
    } 
} 

private class PrintingMock: Printing {

    var printReceivedValue: String? = nil
    func print(_ string: String) {
        printReceivedValue = string
    }
}

private class StorageWorkingMock: StorageWorking {

    var saveCalled = false
    func save(_ storage: Storage) {
        saveCalled = true
    }

    var loadReturnValue: Storage? = nil
    func load() -> Storage? {
        loadReturnValue
    }
}

private class RepositoryManagingMock: RepositoryManaging {

    var appendReturnValue: Repository = .build()
    func append(_ newBranch: Branch, onto currentBranch: Branch, into repository: Repository) -> Repository {
        appendReturnValue
    } 

    var chainReturnValue: Chain? = nil
    func chain(in repository: Repository, with branch: Branch) -> Chain? {
        chainReturnValue
    }
}
