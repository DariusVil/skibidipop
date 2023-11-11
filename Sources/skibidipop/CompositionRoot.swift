struct CompositionRoot {

    static var controller: Controlling { Controller(gitInterpreter: gitInterpreter) }

    private static var gitInterpreter: GitInterpreting {
        GitInterpreter()
    }
}
