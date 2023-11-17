struct Repository: Equatable {

    let chains: [Chain]

    init(chains: [Chain]) {
        self.chains = chains
    }
}

extension Repository: Codable {
    enum CodingKeys: String, CodingKey {
        case chains = "chains"
    }
}
