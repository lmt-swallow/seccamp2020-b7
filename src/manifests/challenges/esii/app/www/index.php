<?php
$cparams = session_get_cookie_params();
session_set_cookie_params(
    $cparams["lifetime"],
    $cparams["path"],
    $cparams["domain"],
    $cparams["secure"],
    TRUE,
);
session_start();

if (!isset($_GET['q'])) {
    header('Location: /?q=<s>XSS</s>');
    exit;
}
?>

<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Leak PHPSESSID!</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.8.2/css/bulma.min.css">
    <script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>
</head>

<body>
    <section class="section">
        <div class="container">
            <h1 class="title">
                Leak PHPSESSID!
            </h1>
        </div>
    </section>
    <section class="section">
        <div class="container">
            <p>以下に XSS 脆弱性があります。
                <pre>alert('Cookie 中の PHPSESSID の値を含む文字列')</pre> をなんとかして実行してください！</p>
            <p>ヒント: PHPSESSID には HttpOnly 属性が付与されているため、
                <pre>alert(document.cookie)</pre> とはできませんが、ESI を利用すると…</p>
            <?= $_GET['q'] ?>
        </div>
    </section>
</body>

</html>