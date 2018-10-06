import { Component } from '@angular/core';
import { NavController, Platform } from 'ionic-angular';

declare var Sample: any;

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {
  constructor(public navCtrl: NavController, public platform: Platform) {
    // プラットフォーム(iOS)で処理の準備ができた時
    this.platform.ready().then(() => {
      // Sampleプラグインの各メソッドを呼び出す
      Sample.hello('Tom!', this.onSuccess, this.onError);
      // Sample.startTimer(this.onSuccess);
      // Sample.getUserLocation(this.onSuccess, this.onError);
    });     
  }
  
  onSuccess(message) {
    alert(message)
  }

  onError(error) {
    console.log(`error: ${error}`);
  }
}
