<?php
	session_start();
	include 'db.php';
	$truckname = $_GET['page'];
?>
<?php
	if($_SESSION['user'] == NULL) {
		header("location: login.php");
		exit;
	}
?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
        <title><?php echo $truckname; ?></title>
        <link rel="stylesheet" type="text/css" href="public/stylesheet/navbar.css">
		<link rel="stylesheet" type="text/css" href="public/stylesheet/fooddescription.css">
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
		<div class="overlay">
			<div class="foodtruckname">
				<h1 class="header-heading"><?php echo $truckname; ?></h1>
				<a href="edit.php?edit=<?php echo $truckname ?>" class="edit"><i class="fa fa-pencil-square-o" aria-hidden="true"></i> EDIT </a>
				<a href="deletefoodtruck.php?delete=<?php echo $truckname ?>" class="delete"><i class="fa fa-trash" aria-hidden="true"></i> DELETE </a></p>
			</div>
		</div>
		<div class="headerbanner">
			<div class="header-image">
				<?php
					$image = selectImage($truckname);
					for ($i = 0; $i < count($image); $i++) {
						echo '<img src="data:image;base64,' . $image[$i]['image'] . ' " class="image">';
					}

				?>
			</div>
		</div>

		<div id="container">
			 <div class="container">
				 <h2 style="text-align:center;">About <?php echo $truckname; ?></h2>
				 <hr class="bar">

				 <?php
			 		$list = selecttruck($truckname);
			 		for ($i = 0; $i < count($list); $i++) {
						echo '<p class="desc">' . $list[$i]['Description'] . '</p>';
			 		}
			 	?>
				<h2 style="text-align:center;">Menu Items</h2>
				<hr class="bar">

				<div class="row">
				<?php
					$list = selectFoodTruckMenu($truckname);
					if (count($list) > 0) {
						for ($i = 0; $i < count($list); $i++) { ?>
								<div class="col-sm-6 menu-item">
									<div class="panel panel-default">
										<div class="panel-body">
											<div class="row">
												<div class="col-xs-12 nameprice">
													<div class="headline">
														<h4><?php echo $list[$i]['Name']; ?></h4>
														<h4 class="price">$<?php echo $list[$i]['Price'] ?></h4>
													</div>
												</div>
											</div>
										 </div>
									 </div>
								 </div>
					<?php }
					 } else {?>
						<div class="nofoodtruckimg">
							<br />
							<h3 style="text-align:center;">You Have No Menu Items</h3>
						</div>
					<?php }
				?>
				</div>
			 </div>

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
