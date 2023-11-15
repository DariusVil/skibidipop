import Foundation

struct StorageManager {
    private let storagePathProvider: StoragePathProviding

    init(storagePathProvider: StoragePathProviding) {
        self.storagePathProvider = storagePathProvider
    }
}

extension StorageManager: StorageManaging {
    func save(_ storage: Storage) {
        do {
            let fileManager = FileManager.default
            let path = storagePathProvider.path

            if !fileManager.fileExists(atPath: path.path) {
                try fileManager.createDirectory(atPath: path.path, withIntermediateDirectories: true)
            }

            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted

            let data = try jsonEncoder.encode(storage)

            if let jsonString = String(data: data, encoding: .utf8) {
                try jsonString.write(
                    toFile: path.appendingPathComponent("storage.json").path,
                    atomically: true,
                    encoding: .utf8
                )
            }
        } catch {
            print("failed to write")
        }
    }

    func load(completion _: @escaping (Storage) -> Void) {
        fatalError("Not implemented")
    }
}
