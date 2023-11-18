struct CompositionRoot {

    static var controller: Controlling { 
        Controller(
            gitInterpreter: gitInterpreter,
            presenter: presenter,
            printer: printer,
            storageManager: storageManager
        ) 
    }

    private static var storageManager: StorageManaging {
        StorageManager(storagePathProvider: storagePathProvider)
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
