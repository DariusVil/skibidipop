import ArgumentParser

@main
struct FigletTool: ParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "Skibidipop",
        abstract: "Git chaining assistant"
    )

    @Argument(help: "Command")
    var command: String

    @Argument(help: "Specify Branch name")
    var branchName: String?

    func run() throws {
        let controller = CompositionRoot.controller

        switch command {
            case "sync":
                controller.sync()
            case "list":
                controller.list()
            case "rebase":
                controller.rebase()
            case "chain":
                guard let branchName else {
                    print("Please specify branch name")

                    return
                }

                controller.chain(branch: branchName)
            default:
                print("Unknown command")
        }
    }
}

