<?php
	session_start();
	if($_SESSION['user'] == NULL) {
		header("location: login.php");
		exit;
	}
?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
        <title>Home</title>
        <link rel="stylesheet" type="text/css" href="public/stylesheet/navbar.css">
		<link rel="stylesheet" type="text/css" href="public/stylesheet/home.css">
		<?php include "htmlhead.php"; ?>
	</head>
	<body>
		<header>
	        <div class="nav">
	        	<ul>
					<li><a href="home.php">Home</a></li>
					<li><a href="newfoodtruck.php">Add Food Truck</a></li>
					<li><a href="contact.php">Contact</a></li>
	            	<li><a href="#"><i class="fa fa-user fa-fw"></i> <?php echo $_SESSION['user'] ?> <i class="fa fa-caret-down fa-lg" aria-hidden="true"></i></a>
	                	<ul>
	                    	<li><a href="#"><i class="fa fa-pencil fa-fw"></i> Profile</a></li>
	                    	<li><a href="logout.php"><i class="fa fa-sign-out" aria-hidden="true"></i> Log Out</a></li>
	                	</ul>
	            	</li>
	            </ul>
	        </div>
	    </header>

		<div class="header-image">
            <div class="overlay">
            	<h1 class="header-heading"><span>Food Trucks</span></h1>
            </div>
        </div>

		<div id="container">
			<?php
				include 'db.php';
				$username = "Pinto";
				$image = selectAllImage();
				$list = selectFoodTrucks($username);

				if (count($list) == 0) {
					echo '<div class="container">';
					echo '<div class="nofoodtruckimg">';
						echo '<h3>You currently have no food trucks.</h3>';
						echo '<hr class="bar">';
						echo '<img src="/public/images/wpid-food-truck.jpg" alt="Smiley face" width="400" height="200" style="margin-bottom:400px;">';
					echo '</div>';
					echo '</div>';
				} else { ?>
					<section class="container">
						<h2 style="text-align:center;">Your Food Trucks</h2>
						<hr class="bar">
						<?php
							for ($i = 0; $i < count($list); $i++) { ?>
								<div class="shading">
									<?php
										echo '<a class="pichover" href="fooddescription.php?page=' . $list[$i]['Name'] . '"><img src="data:image;base64,' . $image[$i]['image'] . ' " class="image " height="25r0px" width="250px"></a>';
									?>
									<p style="text-align: center;"><a class="foodname" href="fooddescription.php?page=<?php echo $list[$i]['Name'] ?>"><?php echo $list[$i]['Name'] ?> </a>
								</div>
							<?php } ?>
					</section>
				<?php }?>

				<footer>
					<div class="wrapper">
						<h2>FIND US ON SOCIAL MEDIA</h2>
						<hr class="footerbar">
						<a href="https://www.facebook.com/" target="_blank"><i class="fa fa-facebook fa-2x" aria-hidden="true"></i></a>
						<a href="https://twitter.com/" target="_blank"><i class="fa fa-twitter fa-2x" aria-hidden="true"></i></a>
						<a href="https://www.instagram.com/" target="_blank"><i class="fa fa-instagram fa-2x" aria-hidden="true"></i></a>
					</div>
					<div class="copy">
						<p>&copy; TruckYeah! 2017</p>
					</div>
				</footer>
		</div>
	</body>
</html>
