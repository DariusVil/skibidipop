protocol StorageManaging {

    func save(_ storage: Storage)
    func load(completion: @escaping (Storage) -> Void)
}