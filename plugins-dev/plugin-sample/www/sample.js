'use strict';

var exec = require('cordova/exec');

var PLUGIN_NAME = 'Sample';

var Sample = {
  hello: function(name, onSuccess, onError) {
    console.log("hello was called!");
    // iOSのクラス(Sample.swift)のメソッドを呼び出す
    // onSuccess: 成功した時に呼ばれるJSのコールバック
    // onError: 失敗した時に呼ばれるJSのコールバック
    // PLUGIN_NAME: plugin.xmlで設定しているプラグイン名
    // 'hello': iOS側のメソッド名
    // [name]: iOS側に渡す引数を配列で渡す
    exec(onSuccess, onError, PLUGIN_NAME, 'hello', [name]);
  },
  startTimer: function(onTimer) {
    console.log("startTimer was called!");
    exec(onTimer, null, PLUGIN_NAME, 'startTimer', []);
  },
  getUserLocation: function(onSuccess, onError) {
    console.log("getUserLocation was called!");
    exec(onSuccess, onError, PLUGIN_NAME, 'getUserLocation', []);
  }
};

module.exports = Sample;
