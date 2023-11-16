struct Storage: Equatable {
    struct Repository: Equatable {
        struct Chain: Equatable {
            struct Branch: Equatable {
                let name: String

                init(name: String) {
                    self.name = name
                }
            }

            let branches: [Branch]

            init(branches: [Branch]) {
                self.branches = branches
            }
        }

        let chains: [Chain]

        init(chains: [Chain]) {
            self.chains = chains
        }
    }

    let repositories: [Repository]

    init(repositories: [Repository]) {
        self.repositories = repositories
    }
}

extension Storage: Codable {

    enum CodingKeys: String, CodingKey {
        case repositories = "repositories"
    }
}

extension Storage.Repository: Codable {
    enum CodingKeys: String, CodingKey {
        case chains = "chains"
    }
}

extension Storage.Repository.Chain: Codable {
    enum CodingKeys: String, CodingKey {
        case branches = "branches"
    }
}

extension Storage.Repository.Chain.Branch: Codable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
