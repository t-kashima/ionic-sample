import Foundation

// 位置情報を取得するのでCoreLocationをimportする
import CoreLocation

@objc(Sample) class Sample : CDVPlugin {
    
    // 非同期のメソッドの対応のためにJコールバックIDを一時的に保存する変数
    fileprivate var saveCallbackId: String? = nil
    
    // 位置情報を取得するManagerを保存しておく変数
    private var locationManager: CLLocationManager? = nil
    
    // 引数にhelloをつけて、JS側のコールバックを呼び出す
    func hello(_ command: CDVInvokedUrlCommand) {
        // パラメータの取得
        // command.argumentsでJS側から渡ってきた引数を取得することができます
        let name = command.arguments[0] as? String ?? ""
        // 引数の文字の前に hello, をつけた文字を作成する
        let message = String(format: "hello, %@", name)
        
        // 成功のコールバックを呼び出す
        // command.callbackIdにJS側から渡ってきた成功の時、失敗の時のコールバックのIDが入っている
        // statusにCDVCommandStatus_OKを設定すると成功のコールバック、
        // statusにCDVCommandStatus_ERRORを設定すると失敗のコールバックが呼ばれる
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
        commandDelegate.send(result, callbackId:command.callbackId)
        
        // 失敗のコールバックを呼び出す
        // let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
        // commandDelegate.send(result, callbackId:command.callbackId)
    }
    
    // タイマーで5秒おきにJS側のコールバックを呼び出す
    func startTimer(_ command: CDVInvokedUrlCommand) {
        // タイマーは非同期なので、コールバックIDをインスタンス変数に保存する
        saveCallbackId = command.callbackId
        
        Timer.scheduledTimer(timeInterval: 5,
                             target: self,
                             selector: #selector(Sample.timerUpdate),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc func timerUpdate() {
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Timer updated")
        // CDVPluginResultにsetKeepCallbackAs(true)を設定すると
        // 何度もコールバックIDを利用してJS側のコールバックを呼ぶことができる
        // 参考: https://qiita.com/JMASystems/items/528b946d7298ba691780
        result?.setKeepCallbackAs(true)
        commandDelegate.send(result, callbackId:saveCallbackId)
    }
    
    // ユーザーの現在位置を取得して、JS側のコールバックを呼び出す
    func getUserLocation(_ command: CDVInvokedUrlCommand) {
        // 位置情報を取得するのは非同期なので、コールバックIDをインスタンス変数に保存する
        saveCallbackId = command.callbackId
        
        // 位置情報の機能が使えるかをチェックする
        if CLLocationManager.locationServicesEnabled() {
            // 位置情報を取得するためのManagerであるCLLocationManagerをインスタンス化する
            let locationManager = CLLocationManager()
            // 位置情報は非同期で取得されるのでDelegateメソッドの実装が必要です (CLLocationManagerDelegate)
            locationManager.delegate = self
            // 現在の位置情報の取得を開始する
            locationManager.startUpdatingLocation()
            
            // locationManagerはローカル変数でスコープを抜けると解放されてしまうので、
            // インスタンス変数に保存して解放されないようにしておく
            self.locationManager = locationManager
        }
    }
}

extension Sample: CLLocationManagerDelegate {
    // 位置情報の機能を使おうとすると初めにこのメソッドが呼ばれ、利用できるかどうかを調べることができる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // まだ利用していいか決めたことがない場合は位置情報利用の許諾アラートを表示する
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    // 現在の位置情報が取得できた時に呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 複数の位置情報が返ってくることがあるので初めの1つだけ取得する
        guard let location = locations.first else {
            return
        }
        // 現在位置の取得を終了する (locationManager.startUpdatingLocationの反対)
        manager.stopUpdatingLocation()

        // ユーザーの位置情報をJS側のコールバックに渡す
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "User location updated latitude: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        commandDelegate.send(result, callbackId:saveCallbackId)
    }
    
    // 現在の位置情報が取得に失敗した時に呼ばれるメソッド
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // エラーのJS側のコールバックを呼び出す
        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error")
        commandDelegate.send(result, callbackId:saveCallbackId)
    }
}
