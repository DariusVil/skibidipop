import XCTest
@testable import skibidipop

final class CommandExecutorTests: XCTestCase {

    private var fixture: Fixture!

    override func setUp() {
        fixture = .init()
    }

    override func tearDown() {
        fixture = nil
    }

    func testExecute_whenCommandIsSync_shouldCallSyncCommand() {
        fixture.sut.execute("sync", branchName: nil)

        XCTAssert(fixture.controllerMock.syncCalled)
    }

    func testExecute_whenCommandIsList_shouldCallListCommand() {
        fixture.sut.execute("sync", branchName: nil)

        XCTAssert(fixture.controllerMock.syncCalled)
    }

    func testExecute_whenCommandIsRebase_shouldCallRebaseCommand() {
        fixture.sut.execute("rebase", branchName: nil)

        XCTAssert(fixture.controllerMock.rebaseCalled)
    }

    func testExecute_whenCommandIsNuke_shouldCallNukeCommand() {
        fixture.sut.execute("nuke", branchName: nil)

        XCTAssert(fixture.controllerMock.nukeCalled)
    }

    func testExecute_whenCommandIsUnknown_shouldPrintError() {
        fixture.sut.execute("optimise", branchName: nil)

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Unknown command"
        )
    }

    func testExecute_whenCommandIsChainAndBranchIsMissing_shouldPrintError() {
        fixture.sut.execute("chain", branchName: nil)

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "Please specify branch name"
        )
    }

    func testExecute_whenCommandIsChainAndBranchGiven_shoulCallChain() {
        fixture.sut.execute("chain", branchName: "my-branch")

        XCTAssert(fixture.controllerMock.chainCalled)
    }
}

private struct Fixture {

    let sut: CommandExecutor
    let printerMock: PrintingMock
    let controllerMock: ControllingMock

    init() {
        printerMock = .init()
        controllerMock = .init()
        sut = .init(controller: controllerMock, printer: printerMock)
    }
}

private class ControllingMock: Controlling {

    var chainCalled = false
    var chainReceivedValue: String?
    func chain(branch: String) {
        chainCalled = true
        chainReceivedValue = branch
    }

    var syncCalled = false
    func sync() {
        syncCalled = true
    }

    var listCalled = false
    func list() {
        listCalled = true
    }

    var rebaseCalled = false
    func rebase() {
        rebaseCalled = true
    }

    var nukeCalled = false
    func nuke() {
        nukeCalled = true
    }
}
