import ArgumentParser

@main
struct Skibidipop: ParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "Skibidipop",
        abstract: "Git chaining assistant"
    )

    @Argument(help: "Command")
    var command: String

    @Argument(help: "Specify Branch name")
    var branchName: String?

    func run() throws {
        let commandExecutor = CompositionRoot.commandExecutor

        commandExecutor.execute(command, branchName: branchName)
    }
}

