import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

protocol StorageWorking {

    func save(_ storage: Storage)
    func load() -> Storage?
    func clean()
}

struct StorageWorker {

    private let storagePathProvider: StoragePathProviding
    private let printer: Printing

    init(storagePathProvider: StoragePathProviding, printer: Printing) {
        self.storagePathProvider = storagePathProvider
        self.printer = printer
    }
}

extension StorageWorker: StorageWorking {

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
            printer.print("Failed to save storage")
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

    func clean() {
        let path = storagePathProvider.path

        guard FileManager.default.fileExists(atPath: path.path) else {
            printer.print("There's nothing to cleanup")
            return
        }

        do {
            try FileManager.default.removeItem(atPath: path.path)
        } catch {
            printer.print("Failed to cleanup")
        }
    }
}
