@testable import skibidipop

extension Storage {

    static func build(repositories: [Repository] = []) -> Self {
        .init(repositories: repositories)
    }
}

extension Repository {

    static func build(chains: [Chain] = [], name: String = "") -> Self {
        Repository.init(chains: chains, name: name)
    }
}

extension Chain {

    static func build(branches: [Branch] = []) -> Self {
        Chain(branches: branches)
    }
}

extension Branch {

    static func build(name: String = "") -> Self {
        Branch(name: name)
    }
}

