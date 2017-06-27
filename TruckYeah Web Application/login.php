<?php session_start(); ob_start(); ?>
<?php
	$failedLoginAttempt = FALSE;
	$inputFields = FALSE;

	if(isset($_SESSION['user'])) {
		header("location: home.php");
	} else if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['login'])) {
		include "db.php";

		$username = $_POST['loginusername'];
		$password = $_POST['loginpassword'];

		$UserRows = selectUser($username, $password);

		if (validateInputs($username, $password) === TRUE) {
			$inputFields = TRUE;
		} else {
			if ($UserRows != NULL) {
				$_SESSION['user'] = $_POST['loginusername'];
				header("location: home.php");
			} else {
				$failedLoginAttempt = TRUE;
			}
		}
	}


	function validateInputs($username, $password) {
		if ($username === "" || $password === "")
			return TRUE;
		return FALSE;
	}

?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Log In</title>
		<link rel="stylesheet" type="text/css" href="public/stylesheet/login.css">
		<?php include "htmlhead.php"; ?>
	</head>
	<body background="public/images/food.jpg">
		<header>
			<div class="overlay">
				<div class="container" id="container">
					<?php
						if ($failedLoginAttempt === TRUE) {
							echo '<p class="alert alert-danger" id="error">
									<strong>Please Try Again. </strong></p>';
						}
						if ($inputFields === TRUE) {
							echo '<p class="alert alert-danger" id="error">
									<strong>Every Field is required.</strong></p>';
						}
					?>
					<form method="post" class="form-login">
						<h2 style="color:#ffffff;text-align:center;">Log In</h2>
						<div class="form-group">
							<label style="font-size:16px;color:#ffffff;">Username</label>
							<input type="text" name="loginusername" class="form-control" placeholder="Username" autofocus/>
						</div>
						<div class="form-group">
							<label style="font-size:16;color:#ffffff;">Password</label>
							<input type="password" name="loginpassword" class="form-control" placeholder="Password" style="margin-bottom:40px"/>
						</div>
						<button type="submit" name="login" class="btn btn-success btn-lg col-md-offset-4" style="margin-bottom:20px">LOGIN</button>
					</form>
					<p style="font-size:15px;text-align:center;color:white">New to TruckYeah!? <a href="register.php" style="color:rgb(255, 191, 0)">Create an account</a></p>
				</div>
			</div>
		</header>

	</body>
</html>
