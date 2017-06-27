<?php session_start();
	ob_start();
?>

<?php
	if(isset($_SESSION['user'])) {
		header("location: index.php");
	} else if (isset($_POST['register'])) {
		include "db.php";
		$username = $_POST['username'];
		$password = $_POST['password'];
		$confirmPassword = $_POST['confirmPassword'];
		$email = $_POST['email'];

		if (validateInputs($username, $password, $confirmPassword, $email) && insertNewUser($username, $email, $password) === TRUE) {
			$_SESSION['user'] = $_POST['username'];
			header("location: home.php");
		} else {
			$failedRegisterAttempt = TRUE;
		}
	}

	function validateInputs($username, $password, $confirmPassword, $email) {
		if (!isset($username) || !isset($password) || !isset($confirmPassword) || !isset($email))
			return TRUE;
		if ($password !== $confirmPassword)
			return TRUE;
		return FALSE;
	}
?>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>Register</title>
		<link rel="stylesheet" type="text/css" href="public/stylesheet/register.css">
		<?php include "htmlhead.php"; ?>
	</head>
	<body background="public/images/food.jpg">
		<header>
			<div class="overlay">
				<div class="container" id="container">
					<?php
						if ($failedRegisterAttempt === TRUE) {
							echo '<p class="alert alert-danger" id="error">
									<strong>Please Try Again. </strong></p>';
						}
					?>
					<form method="post">
						<h2 style="color:#ffffff;text-align:center;">Sign Up</h2>
			            <div class="form-group">
			                <label style="font-size:16px;color:#ffffff;">Username</label>
			                <input type="text" name="username" class="form-control" placeholder="Username" />
			            </div>
			            <div class="form-group">
			                <label style="font-size:16px;color:#ffffff;">Email Address</label>
			                <input type="email" name="email" class="form-control" placeholder="GT Email Address" />
			            </div>
			            <div class="form-group">
			                <label style="font-size:16px;color:#ffffff;">Password</label>
			                <input type="password" name="password" class="form-control" placeholder="Password" />
			            </div>
			            <div class="form-group">
			                <label style="font-size:16px;color:#ffffff;">Confirm Password</label>
			                <input type="password" name="confirmPassword" class="form-control" placeholder="Confirm Password" style="margin-bottom:40px"/>
			            </div>
		                <button type="submit" name="register" class="btn btn-success btn-lg col-md-offset-5" >
		                    CREATE
		                </button>
			        </form>
				</div>
			</div>
		</header>
	</body>
</html>
