import Foundation

protocol CommandPerforming {

    func setWorkingDirectory(into directory: URL)
    @discardableResult
    func run(command: String) -> String
}

final class CommandPerformer {

    var workingDirectory: URL?
}

extension CommandPerformer: CommandPerforming {
    
    func setWorkingDirectory(into directory: URL) {
        self.workingDirectory = directory
    }

    @discardableResult
    func run(command: String) -> String {
        let task = Process()
        if let workingDirectory {
            task.currentDirectoryURL = workingDirectory
        }
        task.executableURL = URL(fileURLWithPath: "/bin/bash")
        task.arguments = ["-c", command]

        print("Running command " + command)

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

