import Foundation

@objc(Sample) class Sample : CDVPlugin {

    func hello(_ command: CDVInvokedUrlCommand) {
        // パラメータの取得
        let name = command.arguments[0] as! String
        let message = String(format: "hello, %@", name)
        
        // 正常
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
        commandDelegate.send(result, callbackId:command.callbackId)
    }
}
