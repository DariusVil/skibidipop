@testable import skibidipop
import XCTest

fileprivate let workingDirectory = "/tmp/skibipopTests"

final class GitInterpreterTests: XCTestCase {
    private var fixture: Fixture!

    override func setUp() {
        fixture = .init()

        createTestDirectory()
    }

    override func tearDown() {
        fixture = nil
        removeTestDirectory()
    }

    func testInitialize_initializesGitRepo() {
        fixture.sut.initialize()

        XCTAssert(fixture.sut.isRepository)
    }

    func testCreateBranch_shouldCreateBranchWithAGivenName() {
        fixture.sut.initialize()

        // we need an initial commit in order for new branch to work
        fixture.commandPerformer.run(command: "touch newfile.txt")
        fixture.sut.add()
        fixture.sut.commit(with: "commit message")

        fixture.sut.createBranch(with: "technical/test-branch")

        let result = fixture.sut.branches
        XCTAssert(result.contains("technical/test-branch"))
    }

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
        sut = GitInterpreter(commandPeformer: CommandPerformer())
    }
}
