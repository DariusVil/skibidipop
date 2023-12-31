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
            "Cant find current branch"
        )
    }

    func testChain_whenSuchBranchAlreadyExists_shouldPrintError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.gitInterpreterMock.branchesReturnValue = ["ios/branchey"]

        fixture.sut.chain(branch: "ios/branchey")
        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Branch with such name already exists in the repository"
        )
    }

    func testChain_whenRepositoryAndBranchExists_shouldCreatebranchCheckoutCommitChanges() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"

        fixture.sut.chain(branch: "ios/branchey")
        XCTAssert(fixture.gitInterpreterMock.createBranchCalled)
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

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Repository not found"
        )
    }

    func testList_givenNoCurrentBranch_shouldPrintAntError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = nil

        fixture.sut.list()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Cant find current branch"
        )
    }

    func testList_givenCantLoadStorage_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = nil

        fixture.sut.list()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Can't load skibidipop configuration. You need to `chain` first"
        )
    }

    func testList_givenCantFindRepository_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = .build()
        fixture.repositoryManagerMock.chainReturnValue = nil

        fixture.sut.list()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "skibidipop configuration is messed up"
        )
    }

    func testList_givenCantFindCurrentChain_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = .build(
            repositories: [.build(name: "Repo")]
        )
        fixture.repositoryManagerMock.chainReturnValue = nil

        fixture.sut.list()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "skibidipop configuration is messed up"
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

    // MARK: - nuke

    func testNuke_shouldCallClean() {
        let fixture = Fixture()

        fixture.sut.nuke()

        XCTAssert(fixture.storageWorkerMock.cleanCalled)
    }

    // MARK: - rebase

    func testRebase_whenChainHasThreeBranches_thenChildBranchesAreRebasedOnTopOfTheirParentsAndReturnsToCurrentBranch() {
        let fixture = Fixture()
        fixture.repositoryManagerMock.chainReturnValue = .build(
            branches: [
                .build(name: "master"), 
                .build(name: "feature-api"), 
                .build(name: "feature-ui") 
            ]
        )
        fixture.storageWorkerMock.loadReturnValue = .build(
            repositories: [
                .build(
                    name: "Repo"
                )
            ]
        )
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "feature-api"

        fixture.sut.rebase()

        XCTAssertEqual(
            fixture.gitInterpreterMock.messages,
            [
                .checkout(branchName: "feature-api"),
                .rebase(branchName: "master"),

                .checkout(branchName: "feature-ui"),
                .rebase(branchName: "feature-api"),

                .checkout(branchName: "feature-api"),
            ]
        )
    }

    func testRebase_givenNotOnRepository_shouldPrintAntError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = nil

        fixture.sut.rebase()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Repository not found"
        )
    }

    func testRebase_givenNoCurrentBranch_shouldPrintAntError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = nil

        fixture.sut.rebase()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Cant find current branch"
        )
    }

    func testRebase_givenCantLoadStorage_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = nil

        fixture.sut.rebase()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Can't load skibidipop configuration. You need to `chain` first"
        )
    }

    func testRebase_givenCantFindRepository_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = .build()
        fixture.repositoryManagerMock.chainReturnValue = nil

        fixture.sut.rebase()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "skibidipop configuration is messed up"
        )
    }

    func testRebase_givenCantFindCurrentChain_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = .build(
            repositories: [.build(name: "Repo")]
        )
        fixture.repositoryManagerMock.chainReturnValue = nil

        fixture.sut.rebase()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "skibidipop configuration is messed up"
        )
    }

    // MARK: - sync

    func testSync_givenNotOnRepository_shouldPrintAntError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = nil

        fixture.sut.sync()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Repository not found"
        )
    }

    func testSync_givenNoCurrentBranch_shouldPrintAntError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = nil

        fixture.sut.sync()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Cant find current branch"
        )
    }

    func testSync_givenCantLoadStorage_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = nil

        fixture.sut.sync()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Can't load skibidipop configuration. You need to `chain` first"
        )
    }

    func testSync_givenCantFindRepository_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = .build()
        fixture.repositoryManagerMock.chainReturnValue = nil

        fixture.sut.sync()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "skibidipop configuration is messed up"
        )
    }

    func testSync_givenCantFindCurrentChain_shouldPrintAnError() {
        let fixture = Fixture()
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "master"
        fixture.storageWorkerMock.loadReturnValue = .build(
            repositories: [.build(name: "Repo")]
        )
        fixture.repositoryManagerMock.chainReturnValue = nil

        fixture.sut.sync()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "skibidipop configuration is messed up"
        )
    }

    func testSync_givenThreeBranchesAreAvailable_shouldPushAllBranchesExceptRootAndReturnToOriginalBranch() {
        let fixture = Fixture()
        fixture.repositoryManagerMock.chainReturnValue = .build(
            branches: [
                .build(name: "master"), 
                .build(name: "feature-api"), 
                .build(name: "feature-ui") 
            ]
        )
        fixture.storageWorkerMock.loadReturnValue = .build(
            repositories: [
                .build(
                    name: "Repo"
                )
            ]
        )
        fixture.gitInterpreterMock.repositoryNameReturnValue = "Repo"
        fixture.gitInterpreterMock.currentBranchReturnValue = "feature-api"

        fixture.sut.sync()

        XCTAssertEqual(
            fixture.gitInterpreterMock.messages,
            [
                .checkout(branchName: "feature-api"),
                .push,
                .checkout(branchName: "feature-ui"),
                .push,
                .checkout(branchName: "feature-api")
            ]
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

    enum Message: Equatable {
        case rebase(branchName: String)
        case checkout(branchName: String)
        case push
    }

    var messages: [Message] = []

    func initialize() {}

    var createBranchCalled = false
    func createBranch(with name: String) {
        createBranchCalled = true
    }

    var checkoutCalled = false
    func checkout(into branchName: String) {
        checkoutCalled = true
        messages.append(.checkout(branchName: branchName))
    }

    func rebase(onto branch: String) {
        messages.append(.rebase(branchName: branch))
    }

    var commitCalled = false
    func commit(with message: String) {
        commitCalled = true
    }

    var addCalled = false
    func add() {
        addCalled = true
    }

    func push() {
        messages.append(.push)
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

private class StorageWorkingMock: StorageWorking {

    var saveCalled = false
    func save(_ storage: Storage) {
        saveCalled = true
    }

    var loadReturnValue: Storage? = nil
    func load() -> Storage? {
        loadReturnValue
    }

    var cleanCalled = false
    func clean() {
        cleanCalled = true
    }
}

private class RepositoryManagingMock: RepositoryManaging {

    var appendReturnValue: Repository = .build()
    func append(_ newBranch: Branch,
        onto currentBranch: Branch,
        into repository: Repository) -> Repository {
        appendReturnValue
    } 

    var chainReturnValue: Chain? = nil
    func chain(in repository: Repository,
        with branch: Branch) -> Chain? {
        chainReturnValue
    }
}
