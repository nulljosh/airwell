import Testing
@testable import Breathe

@Test func url() {
    #expect(breatheURL.host == "breathe.heyitsmejosh.com")
    #expect(breatheURL.scheme == "https")
}
