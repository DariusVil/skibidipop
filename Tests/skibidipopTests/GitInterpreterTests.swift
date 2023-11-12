@testable import skibidipop
import XCTest

final class GitInterpreterTests: XCTestCase {
    private let workingDirectory = "/tmp/skibipopTests"

    private var sut: GitInterpreter!

    override func setUp() {
        sut = GitInterpreter()

        createTestDirectory()
    }

    override func tearDown() {
        removeTestDirectory()
    }

    func testSetWorkingDirectory_changesDirectoryToSpecified() {
        sut.workingDirectory = URL(fileURLWithPath: workingDirectory)
        sut.initialize()

        XCTAssert(isGitRepository(atPath: workingDirectory))
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

    private func isGitRepository(atPath path: String) -> Bool {
        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["-C", path, "rev-parse", "--is-inside-work-tree"]
        process.standardOutput = pipe

        do {
            try process.run()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                return output == "true"
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }

        return false
    }
}

