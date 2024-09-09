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
document.addEventListener('turbolinks:load', () => {
  Rails.start(); // Rails UJSをturbolinks:load後に再スタートさせる
});


// jQueryのインポート
import $ from 'jquery';
window.$ = $;

// 投稿詳細のドロップダウン
document.addEventListener('turbolinks:load', function() {
  document.querySelectorAll('.dropdown-toggle').forEach(function(element) {
    element.addEventListener('click', function(event) {
      const commentId = this.getAttribute('data-comment-id');
      const dropdownMenu = document.getElementById(`dropdown-menu-${commentId}`);
      
      dropdownMenu.classList.toggle('show');
      event.stopPropagation();
    });
  });

  document.addEventListener('click', function() {
    document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
      menu.classList.remove('show');
    });
  });
});


// ヘッダーのドロップダウン
document.addEventListener('turbolinks:load', function() {
  // 各ドロップダウンのトグル要素に対してクリックイベントを追加
  document.querySelectorAll('.dropdown-toggle').forEach(function(element) {
    element.addEventListener('click', function(event) {
      const commentId = this.getAttribute('data-comment-id');
      const dropdownMenu = document.getElementById(`dropdown-menu-${commentId}`);
      
      // すべてのドロップダウンメニューを閉じる
      document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
        menu.classList.remove('show');
      });

      // 対象のドロップダウンメニューを表示/非表示切り替え
      dropdownMenu.classList.toggle('show');
      event.stopPropagation(); // イベントのバブリングを防ぐ
    });
  });

  // ドロップダウンメニューの外側をクリックしたときにメニューを閉じる
  document.addEventListener('click', function() {
    document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
      menu.classList.remove('show');
    });
  });

  // ドロップダウンメニュー内をクリックしても閉じないようにする
  document.querySelectorAll('.dropdown-menu').forEach(function(menu) {
    menu.addEventListener('click', function(event) {
      event.stopPropagation(); // メニュー内クリックでは閉じない
    });
  });
});
