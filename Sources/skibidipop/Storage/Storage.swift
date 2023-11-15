struct Storage {
    struct Respository {
        struct Chain {
            struct Branch {
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

    let repositories: [Respository]

    init(repositories: [Respository]) {
        self.repositories = repositories
    }
}

extension Storage: Codable {

    enum CodingKeys: String, CodingKey {
        case repositories = "repositories"
    }
}

extension Storage.Respository: Codable {
    enum CodingKeys: String, CodingKey {
        case chains = "chains"
    }
}

extension Storage.Respository.Chain: Codable {
    enum CodingKeys: String, CodingKey {
        case branches = "branches"
    }
}

extension Storage.Respository.Chain.Branch: Codable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}