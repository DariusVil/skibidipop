protocol Controlling {

    func chain(branch: String)
    func sync()
    func list()
    func rebase()
}

struct Controller {

    let gitInterpreter: GitInterpreting
    let presenter: Presenting
    let printer: Printing
    let storageManager: StorageManaging
}

extension Controller: Controlling {

    func chain(branch: String) {
        fatalError("Not implemented")
    }

    func sync() {
        fatalError("Not implemented")
    }

    func list() {
        // Get current branch and repo name
        // Use them to find chain
        // Print the chain

        fatalError("Not implemented")
    }

    func rebase() {
        fatalError("Not implemented")
    }
}
