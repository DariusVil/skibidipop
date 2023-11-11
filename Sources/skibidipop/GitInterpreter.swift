protocol GitInterpreting {

    func chain(branch: String)
    func sync()
    func list()
    func rebase()
}

struct GitInterpreter {}

extension GitInterpreter: GitInterpreting {

    func chain(branch: String) {
        fatalError("Not implemented")
    }

    func sync() {
        fatalError("Not implemented")
    }

    func list() {
        fatalError("Not implemented")
    }

    func rebase() {
        fatalError("Not implemented")
    }
}
