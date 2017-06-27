<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>TruckYeah!</title>
		<link rel="stylesheet" type="text/css" href="public/stylesheet/index.css">
		<link rel="stylesheet" type="text/css" href="animate.css">
		<?php include "htmlhead.php"; ?>
	</head>
	<body background="public/images/food.jpg">
		<header>
			<div class="overlay">
				<h1><span>TruckYeah!</span></h1>
				<div class="buttons" style="text-align:center;">
					<form method="get" action="/register">
						<div class="btn">
							<a href="register.php">Register</a>
						</div>
					</form>
					<form method="get" action="/login">
						<div>
							<a href="login.php">LogIn</a>
						</div>
					</form>
				</div>
			</div>
		</header>
	</body>
</html>
