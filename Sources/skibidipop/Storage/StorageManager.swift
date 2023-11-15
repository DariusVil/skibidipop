struct StorageManager {

}

extension StorageManager: StorageManaging {

    func save(_ storage: Storage) {
        fatalError("Not implemented")
    }

    func load(completion: @escaping (Storage) -> Void) {
        fatalError("Not implemented")
    }
}