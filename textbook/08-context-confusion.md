# レスポンスボディの生成に関わる処理系の仕様差を利用した攻撃

この章では、レスポンスボディの生成に関与する処理系が複数あり、かつそれらの間に仕様差が存在する場合に起こりうる問題についてを取り扱います。

## 基礎知識

講義資料の Chapter 02 Section 03 （"レスポンスボディの生成に関わる処理系の仕様差を利用した攻撃"）を参照してください。

## 演習: テンプレートエンジンの混用

以下の Web アプリケーションは、PHP によるサーバサイドでの HTML 生成と、Vue.js のテンプレートエンジンによる HTML 生成を同時に利用しています。

- https://template-confusion.challenge.camp2020.hacq.me/

サーバサイドでの HTML 生成の際には、`htmlspecialchars` 関数により、攻撃に使えそうなめぼしい文字が適切にエスケープされます。
そのため、「名前を教える」の項目に `<script>alert(1)</script>` のような単純な攻撃ペイロードを入力しても、決して XSS 攻撃は実施できません。

一方、Vue.js のテンプレートエンジンにおいて特殊な役割を持つ文字種と、`htmlspecialchars()` が想定する（HTML の）特殊な役割を持つ文字種は異なります。
この事実を使って攻撃が出来ないかを考えてみてください。

## 演習: Edge Side Includes Injection

以下の Web アプリケーションには XSS 脆弱性があります。

- https://esii.challenge.camp2020.hacq.me/?q=XSS

また、この Web アプリケーションは、ミドルウェアとして ESI を解釈する Akamai ETS を利用しています。

これらの条件を上手く利用すると、本来 `HttpOnly` 属性により JavaScript からはアクセスできなくなっている `document.cookie` の値に、JavaScript からアクセスしてやることができます。
以下のその方法の概略を示します。

1. ESI により、Web ページ中に Cookie の値を展開する。
2. Web ページ中に展開された値に、JavaScript からアクセスする。

[ESI の仕様](https://www.w3.org/TR/esi-lang/) を確認しながら、実際にこれを実現するような PoC（Proof of Concept）を作成してみてください。

## 演習（Advanced）: Edge Side Includes Injection の環境構築

実際に ESI を利用するような Web アプリケーションを構築してみてください。また、その Web アプリケーションに XSS 脆弱性があった場合に起こりうるリスクを、XSS の種類（Reflected XSS, Stored XSS, DOM-based XSS）別に論じてください。