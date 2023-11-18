import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol StorageManaging {

    func save(_ storage: Storage)
    func load() -> Storage?
}

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

    func load() -> Storage? {
        let path = storagePathProvider.path.appendingPathComponent("storage.json").path

        guard FileManager.default.fileExists(atPath: path) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let decoder = JSONDecoder()
            let storage = try decoder.decode(Storage.self, from: data)

            return storage
        } catch {
            return nil
        }
    }
}
