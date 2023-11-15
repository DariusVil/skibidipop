@testable import skibidipop

extension Storage {

    static func build(repositories: [Storage.Respository] = []) -> Self {
        .init(repositories: repositories)
    }
}