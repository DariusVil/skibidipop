protocol Presenting {

    func format(_ chain: Chain, selectedBranch: Branch) -> String
}

struct Presenter {}

extension Presenter: Presenting {

    func format(_ chain: Chain, selectedBranch: Branch) -> String {
        chain.branches.map {
            $0.name == selectedBranch.name ? $0.name + "<-" : $0.name
        }
        .joined(separator: "\n")
    }
}
