struct Branch: Equatable {

    let name: String

    init(name: String) {
        self.name = name
    }
}

extension Branch: Codable {

    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
}
