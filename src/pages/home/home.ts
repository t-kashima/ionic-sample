import { Component } from '@angular/core';
import { NavController, Platform } from 'ionic-angular';

declare var Sample: any;

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {
  constructor(public navCtrl: NavController, public platform: Platform) {
    // プラットフォーム (iOS) で処理の準備ができた時
    this.platform.ready().then(() => {
      Sample.hello('Tom!', this.onSuccess, this.onError);
   });     
  }
  
  onSuccess(message) {
    console.log(message)
  }

  onError(error) {
    console.log(`error: ${error}`);
  }
}
