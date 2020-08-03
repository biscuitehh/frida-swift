import Foundation

@objc(FridaScriptDelegate)
public protocol ScriptDelegate {
    @objc optional func scriptDestroyed(_ script: Script)
    
    /// option to recieve json serializer decode gum message as Any (objc objects)
    @objc optional func script(_ script: Script, didReceiveMessage message: Any, withData data: Data?)
    
    /// option to recieve non-decode gum message Data
    @objc optional func script(_ script: Script, didReceiveMessageData message: Data, withData data: Data?)
}
