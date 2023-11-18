import Foundation
@testable import skibidipop
import XCTest

final class StorageManagerTests: XCTestCase {

    private let storagePathProviderStub = StoragePathProvidingStub()
    private let fileManager = FileManager.default

    override func tearDown() {
        try! fileManager.removeItem(atPath: storagePathProviderStub.path.path)
    }

    func testSave_createsDirectoryAndFileAtStoragePath() {
        let sut = StorageManager(storagePathProvider: storagePathProviderStub)

        let storage = Storage.build()

        sut.save(storage)

        XCTAssert(fileManager.fileExists(atPath: storagePathProviderStub.path.path + "/storage.json"))
    }

     func testLoad_loadsJSONContents() {
        let sut = StorageManager(storagePathProvider: storagePathProviderStub)

        let storage = Storage.build(
            repositories: [.build(chains: [.build(branches: [.build(name: "branchName")])])]
        )

        sut.save(storage)

        let expectation = XCTestExpectation(description: "Should load")
        let loadedStorage = sut.load()

        XCTAssertEqual(loadedStorage, storage)     
     }
}

private struct StoragePathProvidingStub: StoragePathProviding {
    var path: URL {
        .init(string: "/tmp/.skibidipop")!
    }
}
