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

    // func testLoad_loadsJSONContents() {
        // TODO fill in this and rename path to dir
    // }
}

private struct StoragePathProvidingStub: StoragePathProviding {
    var path: URL {
        .init(string: "/tmp/.skibidipop")!
    }
}
