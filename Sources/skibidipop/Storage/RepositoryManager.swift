protocol RepositoryManaging {
    func append(_ newBranch: Branch,
                onto currentBranch: Branch,
                into repository: Repository) -> Repository
    func chain(in repository: Repository, with branch: Branch) -> Chain?
}

struct RepositoryManager {}

extension RepositoryManager: RepositoryManaging {

    func append(_ newBranch: Branch,
                onto currentBranch: Branch,
                into repository: Repository) -> Repository {
        var repository = repository


        let currentChainIndex = repository.chains.firstIndex(where: { chain in 
            chain.branches.contains(where: { branch 
                in branch.name == currentBranch.name
            })
        })

        if let currentChainIndex {
            repository.chains[currentChainIndex].branches.append(newBranch)
            return repository
        } else {
            repository.chains.append(.init(branches: [newBranch]))
            return repository
        }
    }

    func chain(in repository: Repository, with branch: Branch) -> Chain? {
        print("#####")
        print(repository)
        print(branch)
        print("#####")
        fatalError("")
        return Chain(branches: [])

        return repository.chains.first(where: { chain in
            chain.branches.contains(where: { $0.name == branch.name }) 
        })
    }
}
