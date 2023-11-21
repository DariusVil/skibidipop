import Foundation

protocol GitInterpreting {
    func initialize()
    func createBranch(with name: String)
    func checkout(into branchName: String)
    func rebase(onto branch: String)
    func commit(with message: String)
    func add()

    var isRepository: Bool { get }
    var branches: [String] { get }
    var currentBranch: String? { get }
    var repositoryName: String? { get }
}

struct GitInterpreter {
    let commandPerformer: CommandPerforming
}

extension GitInterpreter: GitInterpreting {
    func initialize() {
        execute(["init"])
    }

    func createBranch(with name: String) {
        execute(["branch", name])
    }

    func checkout(into branchName: String) {
        execute(["checkout", branchName])
    }

    func rebase(onto branch: String) {
        execute(["rebase", branch])
    }

    func commit(with message: String) {
        execute(["commit", "-m", "\"\(message)\""])
    }

    func add() {
        execute(["add", "."])
    }

    var isRepository: Bool {
        let result = execute(["rev-parse", "--is-inside-work-tree"])
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return result == "true"
    }

    var branches: [String] {
        let result: String = execute(["branch"])
        return result.split(separator: " ").map {
            String($0).trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    var currentBranch: String? {
        let result = execute(["branch", "--show-current"])
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return result.isEmpty ? nil : result
    }

    var repositoryName: String? {
        let result = commandPerformer.run(command: "basename `git rev-parse --show-toplevel`")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return result.isEmpty ? nil : result
    }
}

extension GitInterpreter {
    @discardableResult
    private func execute(_ arguments: [String]) -> String {
        commandPerformer.run(command: "git " + arguments.joined(separator: " "))
    }
}
