struct Storage: Equatable {

    var repositories: [Repository]

    init(repositories: [Repository]) {
        self.repositories = repositories
    }
}

extension Storage: Codable {

    enum CodingKeys: String, CodingKey {
        case repositories = "repositories"
    }
}

extension Storage {
    
    mutating func inject(_ repository: Repository) {
        if let repositoryIndex = repositories.firstIndex(where: { $0.name == repository.name }) {
            repositories[repositoryIndex] = repository
        } else {
            repositories.append(repository)
        }
    }
}
