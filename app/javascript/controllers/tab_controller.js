import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tab"
export default class extends Controller {
  static targets = ["tab", "link"]

  connect() {
    this.tabTargets.forEach(tab => {
      if (tab.id !== "tab1") {
        tab.style.display = "none";
      }
    });
  }

  showTab(event) {
    console.log("showTab_activated")

    event.preventDefault();
    const targetId = event.currentTarget.getAttribute("href").substring(1);

    // 一旦全てのタブの中身を非表示にする
    this.tabTargets.forEach(tab => {
      tab.style.display = "none";
    });

    // 一旦すべてのリンクからactiveクラスを削除する
    this.linkTargets.forEach(link => {
      link.classList.remove("active");
    });

    // クリックされたリンクにactiveクラスを追加し、対応するタブを表示する
    event.currentTarget.classList.add("active");
    document.getElementById(targetId).style.display = "block";

    // 一旦すべてのリンクにhover:textt-blue-300を追加する
    this.linkTargets.forEach(link => {
      link.classList.add("hover:text-blue-300");
    });

    // クリックされたリンクからhover:textt-blue-300を取り除く
    event.currentTarget.classList.remove("hover:text-blue-300");
  }
}
