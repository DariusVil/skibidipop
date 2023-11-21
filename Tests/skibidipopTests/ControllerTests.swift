import XCTest
@testable import skibidipop

final class ControllerTests: XCTestCase {


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

private struct GitInterpretingMock: GitInterpreting {

    func initialize() {}
    func createBranch(with name: String) {}
    func checkout(into branchName: String) {}
    func rebase(onto branch: String) {}
    func commit(with message: String) {}
    func add() {}

    var isRepositoryReturnValue = false
    var isRepository: Bool { isRepositoryReturnValue }

    var branchesReturnValue: [String] = [] 
    var branches: [String] { branchesReturnValue }

    var currentBranchReturnValue: String? = nil
    var currentBranch: String? { currentBranchReturnValue }

    var repositoryNameReturnValue: String? = nil
    var repositoryName: String? { repositoryNameReturnValue }
}

private struct PresentingMock: Presenting {

    var formatReturnValue: String = ""
    func format(_ chain: Chain, selectedBranch: Branch) -> String {
        formatReturnValue
    } 
} 

private struct PrintingMock: Printing {

    func print(_ string: String) {
    }
}

private struct StorageWorkingMock: StorageWorking {

    func save(_ storage: Storage) {}

    var loadReturnValue: Storage? = nil
    func load() -> Storage? {
        loadReturnValue
    }
}

private struct RepositoryManagingMock: RepositoryManaging {

    var appendReturnValue: Repository = .build()
    func append(_ newBranch: Branch, onto currentBranch: Branch, into repository: Repository) -> Repository {
        appendReturnValue
    } 
}
