@testable import skibidipop
import XCTest

final class StorageDecodingTests: XCTestCase {
    func testStorage_initalizesFromJSON() {
        let json = """
        {
                "repositories": [
                    {
                        "name": "repo", 
                        "chains": [
                            {
                                "branches": [
                                    {
                                        "name": "main"
                                    },
                                    {
                                        "name": "firstChange"
                                    },
                                    {
                                        "name": "secondChange"
                                    },
                                    {
                                        "name": "thirdChange"
                                    }
                                ]
                            }
                        ]
                    }             
                ]
        }
        """

        let data = Data(json.utf8)

        let decoder = JSONDecoder()
        let storage: Storage? = try? decoder.decode(
            Storage.self,
            from: data
        )
        guard let storage else {
            fatalError("Failed to parse JSON")
        }

        XCTAssertEqual(
            storage.repositories[0].chains[0].branches[0].name,
            "main"
        )
        XCTAssertEqual(
            storage.repositories[0].chains[0].branches[1].name, 
            "firstChange"
        )
        XCTAssertEqual(
            storage.repositories[0].chains[0].branches[2].name,
            "secondChange"
        )
        XCTAssertEqual(
            storage.repositories[0].chains[0].branches[3].name,
            "thirdChange"
        )
    }
}
