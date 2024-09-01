// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";

// Rails関連の初期化
Rails.start();
Turbolinks.start();
ActiveStorage.start();

// CSSのインポート（必要に応じて）
import "../stylesheets/application"; 

// カスタムJavaScriptやモジュールのインポート
// import "../scripts/custom";

// Turbolinksのロード時に実行する処理
document.addEventListener("turbolinks:load", () => {
  console.log("Turbolinks loaded!");
  // 追加のJavaScriptコード
});

// jQueryのインポート
import $ from 'jquery';
window.$ = $;

document.addEventListener('DOMContentLoaded', function() {
  // ドロップダウンをクリックでトグルする
  document.querySelectorAll('.dropdown-toggle').forEach(function(element) {
    element.addEventListener('click', function(event) {
      const dropdownMenu = this.nextElementSibling;

      // 他の開いているドロップダウンメニューを閉じる
      document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
        if (menu !== dropdownMenu) {
          menu.classList.remove('show');
        }
      });

      // 現在のドロップダウンメニューを表示/非表示切り替え
      dropdownMenu.classList.toggle('show');

      // イベントの伝播を止める
      event.stopPropagation();
    });
  });

  // ページのどこかをクリックした時に開いているドロップダウンを閉じる
  document.addEventListener('click', function() {
    document.querySelectorAll('.dropdown-menu.show').forEach(function(menu) {
      menu.classList.remove('show');
    });
  });
});
