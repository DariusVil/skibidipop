@testable import skibidipop

final class PrintingMock: Printing {

    var printReceivedValue: String? = nil
    func print(_ string: String) {
        printReceivedValue = string
    }
}

