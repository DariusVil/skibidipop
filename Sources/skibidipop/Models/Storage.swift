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
        let repositoryIndex = repositories.firstIndex { 
            $0.name == repository.name 
        }

        if let repositoryIndex {
            repositories[repositoryIndex] = repository
        } else {
            repositories.append(repository)
        }
    }
}
