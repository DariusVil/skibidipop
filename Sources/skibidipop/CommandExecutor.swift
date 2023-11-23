protocol CommandExecuting {

    func execute(_ command: String, branchName: String?)
}

struct CommandExecutor {

    private let controller: Controlling
    private let printer: Printing

    init(controller: Controlling, printer: Printing) {
        self.controller = controller
        self.printer = printer
    }
}

extension CommandExecutor: CommandExecuting {

    func execute(_ command: String, branchName: String?) {
        switch command {
            case "sync":
                controller.sync()
            case "list":
                controller.list()
            case "rebase":
                controller.rebase()
            case "chain":
                guard let branchName else {
                    printer.print("Please specify branch name")

                    return
                }

                controller.chain(branch: branchName)
        case "nuke":
            controller.nuke()
            default:
                printer.print("Unknown command")
        }
    }
}
