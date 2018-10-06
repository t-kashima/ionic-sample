import Foundation
import CoreLocation

@objc(Sample) class Sample : CDVPlugin {

//    private var callbacks = [String:String]()
    fileprivate var saveCallbackId: String? = nil
    private var locationManager: CLLocationManager? = nil

    func hello(_ command: CDVInvokedUrlCommand) {
        // パラメータの取得
//        let name = command.arguments[0] as! String
//        let message = String(format: "hello, %@", name)

        saveCallbackId = command.callbackId

        print("Hello, world123")
        
        if CLLocationManager.locationServicesEnabled() {
            print("start location service")
            let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
            self.locationManager = locationManager
        } else {
            print("stop location service")
        }
        
        // locationManager.requestLocation()

        // self.saveCallbackId = command.callbackId

//         Timer.scheduledTimer(timeInterval: 5,
//             target: self,
//             selector: #selector(Sample.timerUpdate),
//             userInfo: nil,
//             repeats: true)
        // guard let callbackId = saveCallbackId else {
        //     return
        // }
        // let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
        // commandDelegate.send(result, callbackId:command.callbackId)

        // 成功
        // let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: message)
        // // 失敗
        // // let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: message)
        // commandDelegate.send(result, callbackId:command.callbackId)
    }

//     @objc func timerUpdate() {
//         let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "update timer")
//         result?.setKeepCallbackAs(true)
//         commandDelegate.send(result, callbackId:saveCallbackId)
//     }
}

extension Sample:  CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        print("Found new location")
        
        let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: "Found new location")
        commandDelegate.send(result, callbackId:saveCallbackId)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error new location")
        
        let result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Error new location")
        commandDelegate.send(result, callbackId:saveCallbackId)
    }
}
