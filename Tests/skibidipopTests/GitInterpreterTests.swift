@testable import skibidipop
import XCTest

final class GitInterpreterTests: XCTestCase {
    private let workingDirectory = "/tmp/skibipopTests"

    private var sut: GitInterpreter!

    override func setUp() {
        var commandPerformer = CommandPerformer()
        commandPerformer.setWorkingDirectory(into: URL(fileURLWithPath: workingDirectory))
        sut = GitInterpreter(commandPeformer: CommandPerformer())

        createTestDirectory()
    }

    override func tearDown() {
        removeTestDirectory()
    }

    func testInitialize_initializesGitRepo() {
        sut.initialize()

        XCTAssert(sut.isRepository)
    }

    // func testCreateBranch_shouldCreateBranchWithAGivenName() {
    //     sut.initialize()
    //     sut.
    //     sut.createBranch(with: "technical/test-branch")

    //     XCTAssert(sut.branches.contains("technical/test-branch"))
    // }

    private func createTestDirectory() {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: workingDirectory)

        do {
            try fileManager.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
            print("Directory created successfully.")
        } catch {
            print("Error creating directory: \(error.localizedDescription)")
        }
    }

    private func removeTestDirectory() {
        let fileManager = FileManager.default
        let directoryURL = URL(fileURLWithPath: workingDirectory)

        do {
            try fileManager.removeItem(at: directoryURL)
            print("Directory deleted successfully")
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

