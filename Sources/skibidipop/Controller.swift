protocol Controlling {

    func chain(branch: String)
    func sync()
    func list()
    func rebase()
    func nuke()
}

struct Controller {

    let gitInterpreter: GitInterpreting
    let presenter: Presenting
    let printer: Printing
    let storageWorker: StorageWorking
    let repositoryManager: RepositoryManaging
}

extension Controller: Controlling {

    func chain(branch: String) {
        guard let repositoryName, let currentBranchName else {
            return
        }

        guard !gitInterpreter.branches.contains(where: { $0 == branch }) else {
            printer.print("Branch with such name already exists in the repository")
            return
        }

        let currentBranch = Branch(name: currentBranchName)
        let newBranch = Branch(name: branch)

        var storage = storageWorker.load() ?? Storage(
            repositories: [.init(chains: [], name: repositoryName)]
        )

        var updatedRepository: Repository {
            var currentRepository: Repository {
                let repository = storage.repositories.first { 
                    $0.name == repositoryName 
                }

                return repository ?? Repository(name: repositoryName)
            }

            return repositoryManager.append(
                newBranch,
                onto: currentBranch,
                into: currentRepository
            ) 
        }

        storage.inject(updatedRepository)

        storageWorker.save(storage)

        gitInterpreter.createBranch(with: branch)
        gitInterpreter.checkout(into: branch)
        gitInterpreter.add()
        gitInterpreter.commit(with: branch)
    }

    func sync() {
        fatalError("Not implemented")
    } 

    func list() { 
        guard let currentChain, let currentBranchName else { 
            return 
        } 

        let string = presenter.format(
            currentChain,
            selectedBranch: Branch(name: currentBranchName)
        )

        printer.print(string)
    }

    func rebase() {
        guard let currentChain, let currentBranchName else {
            return
        }

        currentChain.branches.enumerated().forEach { index, branch in
            guard index != 0 else {
                return
            }

            let parentBranch = currentChain.branches[index - 1]

            gitInterpreter.checkout(into: branch.name)
            gitInterpreter.rebase(onto: parentBranch.name)
        } 

        gitInterpreter.checkout(into: currentBranchName)
    }

    func nuke() {
        storageWorker.clean()
    }
}

private extension Controller {

    var repositoryName: String? {
        if let repositoryName = gitInterpreter.repositoryName {
            return repositoryName
        } else {
            printer.print("Repository not found")
            return nil
        }
    }

    var currentBranchName: String? {
        if let currentBranchName = gitInterpreter.currentBranch {
            return currentBranchName
        } else {
            printer.print("Cant find current branch")
            return nil
        }
    }

    var storage: Storage? {
        if let storage = storageWorker.load() {
            return storage
        } else {
            printer.print("Can't load skibidipop configuration. You need to `chain` first")
            return nil
        }
    }

    var currentChain: Chain? {
        guard let repositoryName, let currentBranchName, let storage else {
            return  nil
        }

        let repository = storage.repositories.first {
            $0.name == repositoryName 
        } 

        if let repository, let chain = repositoryManager.chain(
            in: repository, 
            with: Branch(name: currentBranchName)
        ) {
            return chain
        } else {
            printer.print("skibidipop configuration is messed up")
            return nil
        }
    }
}
