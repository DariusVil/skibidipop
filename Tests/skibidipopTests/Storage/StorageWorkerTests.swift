import Foundation
@testable import skibidipop
import XCTest

final class StorageWorkerTests: XCTestCase {

    private let fileManager = FileManager.default

    private var fixture: Fixture!

    override func setUp() {
        fixture = .init()
    }

    override func tearDown() {
        do {
            try fileManager.removeItem(
                atPath: fixture.storagePathProviderStub.path.path
            )
        } catch {
        }
    }

    func testSave_createsDirectoryAndFileAtStoragePath() {
        let storage = Storage.build()

        fixture.sut.save(storage)

        let path = fixture.storagePathProviderStub.path.path + "/storage.json"
        let fileExists = fileManager.fileExists(atPath: path)
        XCTAssert(fileExists)
    }

     func testLoad_loadsJSONContents() {
        let storage = Storage.build(
            repositories: [
                .build(
                    chains: [
                        .build(branches: [.build(name: "branchName")])
                    ]
                )
            ]
        )

        fixture.sut.save(storage)

        let loadedStorage = fixture.sut.load()

        XCTAssertEqual(loadedStorage, storage)     
     }

    // MARK: - clean

    func testClean_givenStorageExists_removesPathDirectoryWithItContent() {
        let storage = Storage.build()

        fixture.sut.save(storage)
        fixture.sut.clean()

        let storageFolderExists = fileManager.fileExists(
            atPath: fixture.storagePathProviderStub.path.path
        )

        XCTAssertFalse(storageFolderExists)
    }

    func testClean_givenStorageIsMissing_printsError() {
        fixture.sut.clean()

        XCTAssertEqual(
            fixture.printerMock.printReceivedValue,
            "There's nothing to cleanup"
        )
    }
}

private struct Fixture {

    let sut: StorageWorker
    let storagePathProviderStub: StoragePathProvidingStub
    let printerMock: PrintingMock

    init() {
        printerMock = .init()
        storagePathProviderStub = .init()
        sut = .init(
            storagePathProvider: storagePathProviderStub,
            printer: printerMock
        )
    }
}

private struct StoragePathProvidingStub: StoragePathProviding {
    var path: URL {
        .init(string: "/tmp/.skibidipop")!
    }
}
