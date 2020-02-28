import Foundation

@dynamicCallable
public struct RpcFunction {
    public unowned let script: Script
    public let functionName: String

    public init(script: Script, functionName: String) {
        self.script = script
        self.functionName = functionName
    }

    public func dynamicallyCall(withArguments args: [Any]) -> RpcRequest {
        return script.rpcPost(functionName: functionName,
                              requestId: script.nextRequestId, values: args)
    }
}
