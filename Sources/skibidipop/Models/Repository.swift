struct Repository: Equatable {

    let name: String
    var chains: [Chain]

    init(chains: [Chain], name: String) {
        self.chains = chains
        self.name = name
    }

    init(name: String) {
        self.chains = []
        self.name = name
    }
}

extension Repository: Codable {
    enum CodingKeys: String, CodingKey {
        case chains = "chains"
        case name = "name"
    }
}
