@testable import skibidipop

extension Storage {

    static func build(repositories: [Storage.Repository] = []) -> Self {
        .init(repositories: repositories)
    }
}

extension Storage.Repository {

    static func build(chains: [Storage.Repository.Chain]) -> Self {
        Storage.Repository.init(chains: chains)
    }
}

extension Storage.Repository.Chain {

    static func build(branches: [Storage.Repository.Chain.Branch]) -> Self {
        Storage.Repository.Chain(branches: branches)
    }
}

extension Storage.Repository.Chain.Branch {

    static func build(name: String = "") -> Self {
        Storage.Repository.Chain.Branch(name: name)
    }
}

