struct Repository: Equatable {

    let name: String
    let chains: [Chain]

    init(chains: [Chain], name: String) {
        self.chains = chains
        self.name = name
    }
}

extension Repository: Codable {
    enum CodingKeys: String, CodingKey {
        case chains = "chains"
        case name = "name"
    }
}
