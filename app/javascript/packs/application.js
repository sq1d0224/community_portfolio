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

// jQueryのインポート
import $ from 'jquery';
window.$ = $;


// Turbolinksのロード時に実行する処理
document.addEventListener('turbolinks:load', () => {
  console.log("Turbolinks loaded!");

  // ドロップダウンメニューの処理をまとめた関数
  const setupDropdowns = () => {
    document.querySelectorAll('.dropdown-toggle').forEach(function(element) {
      element.addEventListener('click', function(event) {
        const dropdownMenu = element.nextElementSibling; // 隣接するドロップダウンメニュー
        dropdownMenu.classList.toggle('show');
        event.stopPropagation();
      });
    });

    // ドロップダウンメニューの外側をクリックしたときに閉じる
    document.addEventListener('click', function() {
      document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
        menu.classList.remove('show');
      });
    });
  };

  // すべてのドロップダウンを設定
  setupDropdowns();
});
