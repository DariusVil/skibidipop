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

        guard let currentBranchName = gitInterpreter.currentBranch else {
            printer.print("Cant checkout from current branch")
            return
        }

        let currentBranch = Branch(name: currentBranchName)
        let newBranch = Branch(name: branch)

        var storage = storageWorker.load() ?? Storage(repositories: [.init(chains: [], name: repositoryName)])

        var updatedRepository: Repository {
            if let repository = storage.repositories.first(where: { $0.name == repositoryName }) {
                return repositoryManager.append(
                    newBranch,
                    onto: currentBranch,
                    into: repository
                ) 
            } else {
                return Repository(chains: [.init(branches: [newBranch])], name: repositoryName)
            } 
        }

        storage.append(repository: updatedRepository)

        storageWorker.save(storage)

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
