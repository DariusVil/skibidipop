protocol TextFormatting {

    func format(_ chain: Chain, selectedBranch: Branch) -> String
}

struct TextFormatter {}

extension TextFormatter: TextFormatting {

    func format(_ chain: Chain, selectedBranch: Branch) -> String {
        chain.branches.map {
            $0.name == selectedBranch.name ? $0.name + "<-" : $0.name
        }
        .joined(separator: "\n")
    }
}
