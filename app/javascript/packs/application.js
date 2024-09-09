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



// ドロップダウンメニューをクリックで表示するスクリプト
document.addEventListener('DOMContentLoaded', function() {
  const dropdownToggle = document.querySelector('.header-user-profile');
  const dropdownContent = document.querySelector('.header-dropdown-content');

  if (dropdownToggle && dropdownContent) {  // 要素が存在する場合のみイベントを追加
    dropdownToggle.addEventListener('click', function(event) {
      // ドロップダウンの表示/非表示を切り替え
      dropdownContent.style.display = dropdownContent.style.display === 'block' ? 'none' : 'block';

      // クリックイベントがバブリングしないようにする
      event.stopPropagation();
    });

    // ページ全体でクリックがあった場合にドロップダウンを閉じる
    document.addEventListener('click', function() {
      dropdownContent.style.display = 'none';
    });

    // ドロップダウン内をクリックしても閉じないようにする
    dropdownContent.addEventListener('click', function(event) {
      event.stopPropagation();
    });
  }
});
