struct Storage: Equatable {

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
