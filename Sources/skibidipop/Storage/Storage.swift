struct Storage {
    struct Respository {
        struct Chain {
            struct Branch {
                let name: String
            }

            let branches: [Branch]
        }

        let chains: [Chain]
    }

    let repositories: [Respository]
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