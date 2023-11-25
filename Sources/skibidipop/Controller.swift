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
        guard let repositoryName = gitInterpreter.repositoryName else {
            printer.print("Repository not found")
            return
        }

        guard let currentBranchName = gitInterpreter.currentBranch else {
            printer.print("Cant checkout from current branch")
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
        guard let repositoryName = gitInterpreter.repositoryName else {
            printer.print("Repository not found")
            return
        }

        guard let currentBranchName = gitInterpreter.currentBranch else {
            printer.print("Cant find current branch")
            return
        }

        guard let storage = storageWorker.load() else {
            printer.print("Can't load skibidibop configuration. You need to `chain` first")
            return
        }

        let repository = storage.repositories.first { 
            $0.name == repositoryName 
        } 
        guard let repository = repository else {
            return
        }

        let currentChain = repositoryManager.chain(
            in: repository, 
            with: Branch(name: currentBranchName)
        )
        guard let currentChain else {
            printer.print("skibidibop configuration is messed up")
            return
        }

        let string = presenter.format(
            currentChain,
            selectedBranch: Branch(name: currentBranchName)
        )

        printer.print(string)
    }

    func rebase() {
        guard let repositoryName = gitInterpreter.repositoryName else {
            printer.print("Repository not found")
            return
        }

        guard let currentBranchName = gitInterpreter.currentBranch else {
            printer.print("Cant find current branch")
            return
        }

        guard let storage = storageWorker.load() else {
            printer.print("Can't load skibidibop configuration. You need to `chain` first")
            return
        }

        let repository = storage.repositories.first { 
            $0.name == repositoryName 
        } 
        guard let repository = repository else {
            return
        }

        let currentChain = repositoryManager.chain(
            in: repository, 
            with: Branch(name: currentBranchName)
        )

        guard let currentChain else {
            printer.print("skibidibop configuration is messed up")
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
