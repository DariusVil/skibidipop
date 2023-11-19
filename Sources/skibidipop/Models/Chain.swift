struct Chain: Equatable {

    var branches: [Branch]

    init(branches: [Branch]) {
        self.branches = branches
    }
}

extension Chain: Codable {
    enum CodingKeys: String, CodingKey {
        case branches = "branches"
    }
}

