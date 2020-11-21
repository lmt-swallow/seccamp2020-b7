<head>
	<script src="https://cdn.jsdelivr.net/npm/vue@2.6.12/dist/vue.js"></script>
</head>

<body>
	<h1>Vue.js + PHP</h1>
	<div id="app">
		<p>私の名前は {{ name }} です.</p>
		<p><?= isset($_GET['payload']) ? "こんにちは、" . $_GET['payload'] . "さん!" : "あなたの名前を教えてくだささい！" ?></p>
	</div>

	<h1>名前を教える</h1>
	<form>
		<input type="text" id="payload" name="payload" placeholder="名前">
		<input type="submit" value="GO">
	</form>

	<script>
		const el = new Vue({
			el: '#app',
			data: {
				name: 'seccamp Taro'
			}
		});
	</script>

	<h1>src</h1>
	<?php highlight_string(file_get_contents(basename(__FILE__))); ?>
</body>