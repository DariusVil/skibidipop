import Foundation
@testable import skibidipop
import XCTest

final class StoragePathProviderTests: XCTestCase {
    func testPath_returnsHomeDirectoryPlusHiddenSkibidipop() {
        let path = StoragePathPathProvider().path

        XCTAssertEqual(
            path.path,
            FileManager.default.homeDirectoryForCurrentUser.path + #"/.skibidipop"#
        )
    }
}
