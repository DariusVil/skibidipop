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
        guard let repositoryName = gitInterpreter.repositoryName else {
            printer.print("Repository not found")
            return
        }


        gitInterpreter.checkout(into: branch)
        gitInterpreter.add()
        gitInterpreter.commit(with: branch)

        let storage = storageManager.load()
        if storage == nil {
            let initialStorage = Storage(repositories: [Repository(chains: [.init(branches: [.init(name: branch)])], name: repositoryName)])
            storageManager.save(initialStorage)
        } else {
            // need to update find current chain here, update it with a new branch and save it
        }
    }

    func sync() {
        fatalError("Not implemented")
    }

    func list() {
        // Get current branch and repo name
        // Load storage
        // Use them to find chain
        // Print the chain

        fatalError("Not implemented")
    }

    func rebase() {
        fatalError("Not implemented")
    }
}
