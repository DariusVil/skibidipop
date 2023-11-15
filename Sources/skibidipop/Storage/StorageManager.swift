import Foundation

struct StorageManager {
    private let storagePathProvider: StoragePathProviding

    init(storagePathProvider: StoragePathProviding) {
        self.storagePathProvider = storagePathProvider
    }
}

extension StorageManager: StorageManaging {
    func save(_: Storage) {
        // do {
        //     try FileManager.default.createDirectory(
        //         at: path,
        //         withIntermediateDirectories: true,
        //         attributes: nil
        //     )
        //     print("Folder created at: \(folderPath.path)")
        // } catch {
        //     print("Error creating folder: \(error.localizedDescription)")
        // }
    }

    func load(completion _: @escaping (Storage) -> Void) {
        fatalError("Not implemented")
    }
}
