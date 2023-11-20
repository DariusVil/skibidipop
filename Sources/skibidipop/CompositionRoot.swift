struct CompositionRoot {

    static var controller: Controlling { 
        Controller(
            gitInterpreter: gitInterpreter,
            presenter: presenter,
            printer: printer,
            storageWorker: storageWorker,
            repositoryManager: repositoryManager
        ) 
    }

    private static var repositoryManager: RepositoryManager {
        RepositoryManager()
    }

    private static var storageWorker: StorageWorking {
        StorageWorker(storagePathProvider: storagePathProvider)
    }

    private static var storagePathProvider: StoragePathProviding {
        StoragePathPathProvider()
    }

    private static var presenter: Presenting {
        Presenter()
    }

    private static var printer: Printing {
        Printer()
    }

    private static var gitInterpreter: GitInterpreting {
        GitInterpreter(commandPeformer: commandPerformer)
    }

    private static var commandPerformer: CommandPerforming {
        CommandPerformer()
    }
}
