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
}

struct GitInterpreter {

    let commandPeformer: CommandPerforming
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

    func rebase(onto _: String) {
        execute(["rebase", "master"])
    }

    func commit(with message: String) {
        execute(["commit", "-m", message])
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
        return result.split(separator: "\n").map { String($0) }
    }
}

extension GitInterpreter {

    private func execute(_ arguments: [String]) -> String {
        commandPeformer.run(command: "git " + arguments.joined(separator: " "))
    }
}
