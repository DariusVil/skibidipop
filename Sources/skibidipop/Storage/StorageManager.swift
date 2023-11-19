protocol StorageManaging {
    func append(_ newBranch: Branch, onto currentBranch: Branch, into repository: Repository) -> Repository
}

struct StorageManager {

}

extension StorageManager: StorageManaging {

    func append(_ newBranch: Branch, onto currentBranch: Branch, into repository: Repository) -> Repository {
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
}
