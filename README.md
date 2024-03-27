■サービス概要
毎日の食事と便の時間と状態を記録して管理するアプリです。
自分の記録を振り返って、健康を管理する一般的な使用用途に加えて、
独自のアルゴリズムで食事と便の関係性を判断し、相性の良い食事、悪い食事を教えてくれます。

■ このサービスへの思い・作りたい理由
私は生まれつき下痢症で、中学時代には毎朝腹痛で通学電車を途中下車してトイレに行く人生でした。
社会人になってから食事と便の関係性に注目するようになり、色々な食事を試してはお腹の調子を観察し、
何を食べると調子を崩すのかを少しずつ知っていき、相性の悪い食事を極力避けることで、症状を改善した経験があります。
28歳となった今でも、自分の胃腸と食事の相性を意識してメニューを選んでいるのですが、これを記録するだけで
サポートしてくれるアプリが欲しいなと思ったことから、作成を決めました。
また、自分と同じように胃腸が弱い人の役に立つとも思っています。

■ ユーザー層について
全年齢、慢性的に胃腸の問題を抱えている人


■サービスの利用イメージ
ユーザーはLinebotのトーク画面から食事と便をする度に、その内容を入力して記録します。
記録が溜まっていくと、自分と相性の良い食事と悪い食事の情報をアプリがLineで教えてくれます。
また、ブラウザからアプリにアクセスすることで、自身の食事と便の記録を振り返ったり、
これまでに判定された食事との相性の一覧を確認することができます。
これにより、自身の食生活を振り返りながら、胃腸の調子を改善していくことができます。

■ ユーザーの獲得について
・RUNTEQコミュニティの胃腸の弱い人に使ってもらう。
・類似アプリの数が少ないので、便　記録・便　管理などのキーワード検索からの流入を狙います。


■ サービスの差別化ポイント・推しポイント
明確な差別化ポイントとして、食事と便の相関に注目している点があります。
食事管理アプリはダイエットや栄養管理を主目的として様々な種類が存在し、排便管理アプリも2つほど確認できました。
しかしながら、その2つを組み合わせ、その相関に注目したアプリは存在しません。
自身の経験から、普段の食事内容が胃腸の問題に直結している人はいると考えているので、
そのような人たちに対して、唯一無二の価値を届けられると思います。

■ 機能候補
【MVPリリース】
linebot
line会員登録
会員登録
ログイン
食事と便の記録
食事と便の相関を判定するアルゴリズム
相性判定結果の一覧表示

【本リリース】
おすすめ食事のレコメンド
食事メニューへのコメント
食事メニューの検索
カレンダーで記録の確認
ブラウザからの一括記録

■ 機能の実装方針予定
・bot、会員登録、ログイン
  line-bot-api gemの使用を想定

・Linebotの入力画面構成
  LINEbotのリッチメニューに、便記録・食事記録・サイトへアクセスのボタンが用意されています。
  便記録ボタンを押すと、ボタンテンプレートを利用して選択肢「1.良い　2.悪い　3.なんとも言えない」が付属したメッセージが
  botから送られてくるので、ユーザーはその選択肢をクリックします。
  食事記録ボタンを押すと、「食事の名前を送ってください。」と言うメッセージがbotから送られてくるので、
  ユーザーは食事の名前をテキストで送信します。
  サイトへアクセスのボタンを押すと、ブラウザで本アプリのログイン後ユーザー詳細画面にアクセスします。

・食事と便の判定アルゴリズム、相性判定結果の一覧表示
  ユーザーが便の状態を登録する際、「1.良い　2.悪い　3.なんとも言えない」の3つの選択肢から選択して登録します。
  食事が便として排泄される時間には個人差があり、24時間〜48時間と言われているので、このアプリでは便の状態の原因として、
  排便から20時間~50時間前の範囲で食べた食事を疑うこととしています。
  ユーザーが食事の記録を行った場合、ユーザーデータと食事データを紐付け評価値を記録する「評価テーブル」にデータが作成されます。
  「評価値テーブル」には、user_id, meal_id, evaluation_valueのカラムがあります。evaluation_valueのデフォルトは0です。
  ユーザーが便の記録を「2.悪い」で行った場合、その記録時間から20~50時間の間に同一ユーザーによって記録された食事のevaluation_valueを-1します。
  ユーザーが便の記録を「1.良い」で行った場合、その記録時間から20~50時間の間に同一ユーザーによって記録された食事のevaluation_valueを+1します。
  evaluation_valueが-3以下の食事をそのユーザーにとっての相性の悪い食事として判定します。
  evaluation_valueが+3以上の食事をそのユーザーにとっての相性の良い食事として判定します。

  evaluation_valueの判定を+3と-3にしているのは、相性の悪い食事を絞り込むためです。

例として、下記のような日時での食事記録があるとします。
4/1 [08:00, おにぎり], [12:00, ラーメン], [19:00, 焼き魚定食]
4/2 [08:00, バナナ], [12:00, 牛丼], [19:00, カレー]
4/3 [08:00, おにぎり], [12:00, 蕎麦], [19:00, ラーメン]
4/4 [08:00, パン], [12:00, のり弁], [19:00, ラーメン]
4/5 [08:00, パン], [12:00, 唐揚げ弁当], [19:00, 豚カツ定食]

その状況下で、4/3の10:00に「悪い便」を記録した場合、その50時間前~20時間前である、4/1 08:00 ~ 4/2 14:00までの範囲で記録されている5回の食事が疑惑の対象となり、おにぎり、ラーメン、焼き魚定食、バナナ、牛丼の5種類の食事のevaluation_valueが-1されます。
この時点では5種類の食事のどれが直接的な原因になっているのか、または食事以外の原因であるかをまだ特定できないと考えます。

そして4/4の21:00にまた「悪い便」が記録されると、4/2 19:00 ~ 4/4 01:00の範囲で記録されている、カレー、おにぎり、蕎麦、ラーメンのevaluation_valueが-1されます。
そして4/5の23:00にまた「悪い便」が記録されると、4/3 21:00 ~ 4/5 03:00の範囲で記録されている、パン、のり弁、ラーメンのevaluation_valueが-1されます。

ここまででevaluation_valueの状況をマイナスが大きい順に見ると下記のようになります。

-3  ラーメン
-2  おにぎり
-1  焼き魚定食、バナナ、牛丼、カレー、蕎麦、パン、のり弁

この時点で、ラーメンのせいでお腹を下しているのでは？と予想し、相性の悪い食事としてユーザーに提示します。
また、今回のおにぎりのように単純に食べる回数が多かった食事が巻き添えを食らう可能性もありますが、
「良い便」を記録すると+1されるため、巻き添えのマイナスは打ち消されると考えています。

・データを元にした記録のカレンダー表示
  simple calender gemの使用を想定

・レコメンド機能
  ユーザーAが評価値マイナスの食事メニューに対して、同じく評価値マイナスになっているユーザーB情報を取得し、
  取得したユーザーBと紐づけられている食事メニューから、評価値がプラスのもの、マイナスのものをレコメンド対象として扱う。
  評価値がプラスのものはおすすめの食事として、マイナスのものは気をつけるべき食事として、ユーザーAに表示する。
  各ユーザーと食事の紐付けと評価値については、食事と便の判定アルゴリズムの実装方針でも記載した「評価テーブル」のデータを使用する。

■ 使用予定の技術スタック
|カテゴリ|技術|
|----|----|
|フロントエンド|javascript/bootstrap/Hotwire|
|バックエンド|ruby on Rails|
|データベース|PostgreSQL|
|認証|sorcery|
|環境構築|Docker / docker-compose|
|CI/CD|Github Actions|
|インフラ|heroku|
|API|LINEログイン/LINE Messaging API|

技術スタックに関しては、目標期間でのアプリの機能実現を最優先と考えているため、
RUNTEQカリキュラムとRails Tutorialで使用したことのある技術を中心に採用しています。

■ 完成スケジュール
  2024/4/22をMVPリリース目標日としています。
  本リリースはMVPリリース後に追加機能の再検討を行い、スケジュールを決定する予定です。

■ 画面遷移図URL
  https://www.figma.com/file/Gz3PGuJz0pdUp5TUxz7Ris/%E5%8D%92%E6%A5%AD%E8%A9%A6%E9%A8%93%E3%82%A2%E3%83%97%E3%83%AA%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?type=design&mode=design&t=g8TSF07mKy0rHjes-1

■ ER図
![Alt text](%E5%90%8D%E7%A7%B0%E6%9C%AA%E8%A8%AD%E5%AE%9A.png)