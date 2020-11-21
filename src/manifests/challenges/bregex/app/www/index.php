<!DOCTYPE html>
<?php
// Challenge: Let's leak $secret!

// this defines $users and $secret.
include 'data.php';

// loosen pcre's backtrack limit to allow complex queries for our good customers :-)
ini_set("pcre.backtrack_limit", "1000000000");

$t1 = microtime(TRUE);

// main logic
if (isset($_POST['query'])) {
	// search
	$result = array_filter($users, function ($v, $k) {
		return preg_match("/" . $_POST['query'] . "/", $v) === 1;
	}, ARRAY_FILTER_USE_BOTH);

	// something like authZ 
	$result = array_reduce(array_map(function ($k, $v) use ($secret) {
		return array($k => ($v === $secret ? "**censored**" : $v));
	}, array_keys($result), $result), function ($acc, $a) {
		return $acc + $a;
	}, []);
} else {
	$result = [];
}

$t2 = microtime(TRUE);
$duration = $t2 - $t1;
?>

<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Search</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.8.2/css/bulma.min.css">
	<script defer src="https://use.fontawesome.com/releases/v5.3.1/js/all.js"></script>
</head>

<body>
	<section class="section">
		<div class="container">
			<h1 class="title">
				Search
			</h1>
		</div>
	</section>
	<section class="section">
		<div class="container">
			<h2 class="title is-2">Search Among Profile</h2>
			<form method="POST">
				<div class="field has-addons">
					<div class="control is-expanded">
						<input class="input" type="text" name="query" placeholder="Query to search among profiles (e.g. Kenta)">
					</div>
					<div class="control">
						<button class="button is-link">Submit</button>
					</div>
				</div>
			</form>

			<div class="tile is-ancestor">
				<?php foreach ($result as $k => $v) { ?>
					<div class="tile is-parent">
						<div class="tile is-child box">
							<p class="title"><?= $k ?></p>
							<p><?= $v ?></p>
						</div>
					</div>
				<?php } ?>
			</div>
		</div>
	</section>
	<section class="section">
		<div class="container">
			<h2 class="title is-2">Source Code</h2>
			<?php highlight_file(__FILE__); ?>
		</div>
	</section>
	<footer class="footer">
		<div class="content has-text-centered">
			<p>
				It took <?= $duration ?> seconds to process your request.
			</p>
		</div>
	</footer>
</body>

</html>