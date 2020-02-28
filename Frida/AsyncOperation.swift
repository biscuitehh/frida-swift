import Frida.Frida_Private

class AsyncOperation<CompletionHandler> {
    let completionHandler: CompletionHandler

    init(_ completionHandler: CompletionHandler) {
        self.completionHandler = completionHandler
    }
}
