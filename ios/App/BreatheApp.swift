import SwiftUI
import WebKit

@main
struct BreatheApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
        #if os(macOS)
        .defaultSize(width: 480, height: 760)
        #endif
    }
}

let breatheURL = URL(string: "https://windgate.heyitsmejosh.com/?embed")!

@MainActor
final class LoadState: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var loading = true
    @Published var failed = false
    func webView(_ w: WKWebView, didFinish n: WKNavigation!) { loading = false; failed = false }
    func webView(_ w: WKWebView, didFail n: WKNavigation!, withError e: Error) { loading = false; failed = true }
    func webView(_ w: WKWebView, didFailProvisionalNavigation n: WKNavigation!, withError e: Error) { loading = false; failed = true }
}

#if os(macOS)
struct WebView: NSViewRepresentable {
    let delegate: LoadState
    func makeNSView(context: Context) -> WKWebView {
        let web = WKWebView()
        web.navigationDelegate = delegate
        web.load(URLRequest(url: breatheURL))
        return web
    }
    func updateNSView(_ v: WKWebView, context: Context) {}
}
#else
struct WebView: UIViewRepresentable {
    let delegate: LoadState
    func makeUIView(context: Context) -> WKWebView {
        let web = WKWebView()
        web.navigationDelegate = delegate
        web.load(URLRequest(url: breatheURL))
        return web
    }
    func updateUIView(_ v: WKWebView, context: Context) {}
}
#endif

struct ContentView: View {
    @StateObject private var state = LoadState()
    var body: some View {
        ZStack {
            Color(red: 0.043, green: 0.078, blue: 0.125).ignoresSafeArea()
            WebView(delegate: state).ignoresSafeArea()
            if state.loading {
                ProgressView().tint(.white)
            }
            if state.failed {
                VStack(spacing: 12) {
                    Text("Couldn't connect").foregroundStyle(.white)
                    Button("Retry") { state.loading = true; state.failed = false }
                }
            }
        }
    }
}
