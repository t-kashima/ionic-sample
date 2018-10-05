import Foundation

@objc(Sample) class Sample : CDVPlugin {

    func initialize(_ command: CDVInvokedUrlCommand) {
        // パラメータの取得
        //command.arguments

        // 正常
        let result = CDVPluginResult(status: CDVCommandStatus_OK)
	    commandDelegate.send(result, callbackId:command.callbackId)
    }
}
