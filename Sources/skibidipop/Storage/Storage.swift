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
    // enum CodingKey: String, CodingKey {
    //     case repositories = "repositories"
    // }
}

extension Storage.Respository: Codable {
    // enum CodingKey: String, CodingKey {
    //     case chain = "chain"
    // }
}

extension Storage.Respository.Chain: Codable {
    // enum CodingKey: String, CodingKey {
    //     case name = "name"
    // }
}

extension Storage.Respository.Chain.Branch: Codable {

}
