import Foundation

protocol StoragePathProviding {

    var path: URL { get }
}

struct StoragePathPathProvider: StoragePathProviding {

    var path: URL {
        FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".skibidipop")
    }
}