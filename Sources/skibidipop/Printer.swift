protocol Printing {

    func print(_ string: String) 
}

struct Printer {}

extension Printer: Printing {

    func print(_ string: String) {
        Swift.print(string)
    }
}
