import XCTest
import XCTVapor
@testable import App
final class HealthTests:XCTestCase { func testHealth() async throws { let app=Application(.testing); defer { app.shutdown() }; try configure(app); try app.test(.GET,"/health",afterResponse:{ res in XCTAssertEqual(res.status,.ok); XCTAssertTrue(res.body.string.contains("shadow-files")) }) } }
