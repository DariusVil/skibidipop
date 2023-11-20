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
    let storageWorker: StorageWorking
    let repositoryManager: RepositoryManager
}

extension Controller: Controlling {

    func chain(branch: String) {
        guard let repositoryName = gitInterpreter.repositoryName else {
            printer.print("Repository not found")
            return
        }

        if let storage = storageWorker.load() {
            if storage.repositories.contains(where: { $0.name == repositoryName }) {
        
            }
            // need to update find current chain here, update it with a new branch and save it
        } else {
            let initialStorage = Storage(
                repositories: [
                    Repository(chains: [.init(branches: [.init(name: branch)])], name: repositoryName)
                ]
            )
            storageWorker.save(initialStorage)
        } 

        gitInterpreter.checkout(into: branch)
        gitInterpreter.add()
        gitInterpreter.commit(with: branch)
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
