import Foundation

protocol GitInterpreting {

    func initialize()
    func rebase(onto branch: String)
}

struct GitInterpreter {}

extension GitInterpreter: GitInterpreting {

    func initialize() {
        execute(["init"])
    }

    func rebase(onto branch: String) {
        execute(["rebase", "master"])
    }

    private func execute(_ arguments: [String]) {
        let task = Process()
        task.executableURL = URL(string: "/usr/bin/git")
        task.arguments = arguments

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
        } catch {

        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            print(output)
        }

        task.waitUntilExit()    
    }
}
