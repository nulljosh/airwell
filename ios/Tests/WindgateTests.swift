import Testing
@testable import Windgate

@Test func url() {
    #expect(breatheURL.host == "breathe.heyitsmejosh.com")
    #expect(breatheURL.scheme == "https")
}
