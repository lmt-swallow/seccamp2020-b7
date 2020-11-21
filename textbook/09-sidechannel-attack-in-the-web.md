# サーバサイド Web システムに対するサイドチャネル攻撃

この章では、Web におけるサイドチャネル攻撃を、少しだけ紹介します。

## 基礎知識

講義資料の Chapter 03 （"サイドチャネル攻撃の基礎"）を参照してください。

## 演習（Optional）: Blind Regex Injection Attack

以下の Web アプリケーションでは、Blind Regex Injection Attack により、本来秘匿されている `$secret` という変数の中身をリークすることができます。

- https://bregex.challenge.camp2020.hacq.me/

["A Rough Idea of Blind Regular Expression Injection Attack"](https://diary.shift-js.info/blind-regular-expression-injection/) や ["Time based Regex Injection"](https://blog.p6.is/time-based-regex-injection/) を参考にして、実際に攻撃を実施してみてください。