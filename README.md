# 「Puri.log」
サービスURL:https://www.puri-log.com/

![Alt text](<Puri.log OGP用画像1200 (1).png>)

### ■ サービス概要

胃腸の弱い人のための食事と排便の記録アプリです。<br>
あなたの胃腸と食事の相性を、記録を元にアプリが判定します。 <br>
LINEBOTを活用し、手軽に記録ができるようになっています。 

### ■ このサービスへの思い・作ることを決めた理由

私は生まれつき胃腸が弱く下痢症で、中学時代には毎朝腹痛で通学電車を途中下車してトイレに行く人生でした。<br>
社会人になってから自身の腹痛の要因が食事にあるのでは？と考え、色々な食事を試しては胃腸の反応を観察することを始めました。<br>
何を食べると調子を崩すのかを少しずつ把握していった私は、相性の悪い食事を極力避けて生活して症状を改善することができました。<br>
28歳となった今でも、自分の胃腸と食事の相性を意識して食べるものを決めているのですが、これを記録するだけでサポートしてくれるアプリが欲しいと考えました。<br>
しかもアプリにすることで、同じような悩みを持った人の助けにもなるのではと思い、このアプリを作ることを決めました。

### ■ アプリの機能

|トップページの説明スライド|LINE連携ログイン|
|----|----|
|[![Image from Gyazo](https://i.gyazo.com/f815b61e66d25c28512e32a111602f13.gif)](https://gyazo.com/f815b61e66d25c28512e32a111602f13)|[![Image from Gyazo](https://i.gyazo.com/8bf68b06cd95b39ee024922ad9b6b08a.gif)](https://gyazo.com/8bf68b06cd95b39ee024922ad9b6b08a)|
|サイトのトップページではスライド形式で、<br>詳しい使用方法を確認できます。|ログインはLINE連携ログインのみに統一しています。<br>ヘッダーからログインできます。|

|初回ログイン時の利用規約モーダル|マイページの記録機能|
|----|----|
|[![Image from Gyazo](https://i.gyazo.com/13ef9e8463f3e97fde7868205cef6819.gif)](https://gyazo.com/13ef9e8463f3e97fde7868205cef6819)|[![Image from Gyazo](https://i.gyazo.com/51aa8015f9f75156c21e8c9a1bc445dc.gif)](https://gyazo.com/51aa8015f9f75156c21e8c9a1bc445dc)|
|初回ログイン時のみ利用規約が表示されます。<br>一度同意すればもう表示されなくなります。|マイページに設置されているフォームから、<br>食事と排便を記録することができます。|

|マイページのタブメニュー①②|マイページのタブメニュー③④|
|----|----|
|[![Image from Gyazo](https://i.gyazo.com/50ca0b89054407fa16c2dad8b98ca93f.gif)](https://gyazo.com/50ca0b89054407fa16c2dad8b98ca93f)|[![Image from Gyazo](https://i.gyazo.com/79d6944f24be0d4fafa2447dd7c3ef1f.gif)](https://gyazo.com/79d6944f24be0d4fafa2447dd7c3ef1f)|
|マイページでは様々なデータを確認できます。|ジャンルごとに4つのタブメニューに分かれています。|

|LINE BOTの記録機能|LINE BOTで自分のデータを確認|
|----|----|
|[![Image from Gyazo](https://i.gyazo.com/66bece8a2075efa08b2c3757a4cd5c89.gif)](https://gyazo.com/66bece8a2075efa08b2c3757a4cd5c89)|[![Image from Gyazo](https://i.gyazo.com/4dfe3e84f8cef5e3a5f0b2ed760d5b4c.gif)](https://gyazo.com/4dfe3e84f8cef5e3a5f0b2ed760d5b4c)|
|LINE BOTからも記録することができます。|LINE BOTでもステータスの一部が確認できます。|

### ■ サービスの差別化ポイント・推しポイント

明確な差別化ポイントとして、対象ユーザーを胃腸の弱い人に絞っている点、食事と便の関係性に注目している点があります。<br>
食事管理アプリはダイエットや栄養管理を主目的として様々な種類が存在し、排便管理アプリも2つほど確認できました。<br>
しかしながら、その2つを組み合わせ、その相関に注目したアプリは存在しませんでした。<br>
自身の体験から、食事と便の関係性に着目することで胃腸の症状を改善することはできると確信しています。<br>
私と同じような悩みを持つ人たちに対して、唯一無二の価値を届けられると思います。  

### ■ 使用している技術
|カテゴリ|技術|
|----|----|
|フロントエンド|stimulus / Hotwire / tailwindCSS / daisyUI|
|バックエンド|Ruby 3.3.0 / Rails 7.1.3.2|
|データベース|MYSQL|
|認証|devise|
|環境構築|Docker / docker-compose|
|CI/CD|Github Actions|
|インフラ|heroku|
|API|LINEログイン / LINE Messaging API|

### ■ 画面遷移図URL   
  https://www.figma.com/file/Gz3PGuJz0pdUp5TUxz7Ris/%E5%8D%92%E6%A5%AD%E8%A9%A6%E9%A8%93%E3%82%A2%E3%83%97%E3%83%AA%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?type=design&mode=design&t=g8TSF07mKy0rHjes-1

### ■ ER図  
![Alt text](<スクリーンショット 2024-06-01 15.58.52.png>)
