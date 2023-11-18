@testable import skibidipop
import XCTest

fileprivate let workingDirectory = "/tmp/skibidipopTests"

final class GitInterpreterTests: XCTestCase {
    private var fixture: Fixture!

    override func setUp() {
        fixture = .init()
        createTestDirectory()
    }

    override func tearDown() {
        removeTestDirectory()
        fixture = nil
    }

    // MARK: - Initialize

    func testInitialize_initializesGitRepo() {
        fixture.sut.initialize()

        XCTAssert(fixture.sut.isRepository)
    }

    // MARK: - CreateBranch

    func testCreateBranch_shouldCreateBranchWithAGivenName() {
        fixture.sut.initialize()

        // we need an initial commit in order for new branch to work
        fixture.commandPerformer.run(command: "touch newfile.txt")
        fixture.sut.add()
        fixture.sut.commit(with: "commit message")

        fixture.sut.createBranch(with: "technical/test-branch")

        XCTAssert(fixture.sut.branches.contains("technical/test-branch"))
    }

    // MARK: - Checkout

    func testCheckout_givenBranchIsAvailable_returnsTrue() {
        fixture.sut.initialize()
        fixture.commandPerformer.run(command: "touch newfile.txt")
        fixture.sut.add()
        fixture.sut.commit(with: "commit message")
        fixture.sut.createBranch(with: "technical/test-branch")

        fixture.sut.checkout(into: "technical/test-branch")

        XCTAssertEqual(fixture.sut.currentBranch, "technical/test-branch")
    }

    // MARK: - Rebase

    func testRebase_whenFeatureBranchIsBehindMain_shouldGetTheCommit() {
        fixture.sut.initialize()

        // Create a new branch
        fixture.commandPerformer.run(command: "touch newfile.txt")
        fixture.sut.add()
        fixture.sut.commit(with: "commit message")
        fixture.sut.createBranch(with: "technical/test-branch")

        // Add a commit to main
        fixture.sut.checkout(into: "main")
        fixture.commandPerformer.run(command: "touch secondfile.txt")
        fixture.sut.add()
        fixture.sut.commit(with: "second commit message")

        fixture.sut.checkout(into: "technical/test-branch")

        fixture.sut.rebase(onto: "main")

        let commitDiff = fixture.commandPerformer.run(command: "git log technical/test-branch..main")
        XCTAssert(commitDiff.isEmpty)
    }

    // MARK: - RepositoryName

    func testRepositoryName_givenRepositoryDoesNotExist_returnsNil() {
        XCTAssertNil(fixture.sut.repositoryName)
    }

    func testRepositoryName_givenRepositoryExists_returnsRepositoryName() {
        fixture.sut.initialize()

        XCTAssertEqual(fixture.sut.repositoryName, "skibidipopTests")
    }
}

private extension GitInterpreterTests {
    private func createTestDirectory() {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: workingDirectory)

        do {
            try fileManager.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }

    private func removeTestDirectory() {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: workingDirectory)

        do {
            try fileManager.removeItem(at: directoryURL)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

private struct Fixture {
    let sut: GitInterpreter
    let commandPerformer: CommandPerforming

    init() {
        commandPerformer = CommandPerformer()
        commandPerformer.setWorkingDirectory(into: URL(fileURLWithPath: workingDirectory))
        sut = GitInterpreter(commandPeformer: commandPerformer)
    }
}
