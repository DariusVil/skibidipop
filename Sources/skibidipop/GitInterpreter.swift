import Foundation

protocol GitInterpreting {
    mutating func setWorkingDirectory(to directory: URL)

    func initialize()
    func createBranch(with name: String)
    func checkout(into branchName: String)
    func rebase(onto branch: String)

    var isRepository: Bool { get }
}

struct GitInterpreter {
    var workingDirectory: URL?
}

extension GitInterpreter: GitInterpreting {
    mutating func setWorkingDirectory(to directory: URL) {
        workingDirectory = directory
    }

    func initialize() {
        execute(["init"])
    }

    func createBranch(with name: String) {
        execute(["branch", name])
    }

    func checkout(into branchName: String) {
        execute(["checkout", branchName])
    }

    func rebase(onto _: String) {
        execute(["rebase", "master"])
    }

    var isRepository: Bool {
        let result = execute(["rev-parse", "--is-inside-work-tree"])
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return result == "true"
    }

    @discardableResult
    private func execute(_ arguments: [String]) -> String {
        let task = Process()
        if let workingDirectory {
            task.currentDirectoryURL = workingDirectory
        }
        task.executableURL = URL(fileURLWithPath: "/bin/bash")

        let command = (["git"] + arguments).joined(separator: " ")
        task.arguments = ["-c", command]

        print("arguments" + arguments.description)

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
        } catch {
            print(error)
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            print("output" + output)
            return output
        }

        task.waitUntilExit()

        return ""
    }
}
