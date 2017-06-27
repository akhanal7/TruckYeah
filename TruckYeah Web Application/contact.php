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
		<title>Contact Us</title>
		<link rel="stylesheet" type="text/css" href="public/stylesheet/navbar.css">
		<link rel="stylesheet" type="text/css" href="public/stylesheet/contact.css">
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
				<h1 class="header-heading"><span>Contact Us</span></h1>
			</div>
		</div>

		<div class="body">
			<div class="container">
				<div id="row1">
					<h2 >Email Address</h2>
					<hr class="bar1" align="left" width="37%">
					<p class="row1content">truckyeah@gmail.com</p>
					<br /><br />
					<h2>Telephone Number</h2>
					<hr align="left" class="bar2" width="50%">
					<p class="row1content">(415) 555 - 2530</p>
					<p class="row1content">(415) 555 - 9932​</p>

				</div>
	            <div class="row" id="row2">
					<h1 style="text-align:center;margin-bottom:30px;">Send Us A Message</h1>
	                <div class="col-lg-11 col-lg-offset-0">
	                    <form id="contact-form" method="post" action="contact.php" role="form">
	                        <div class="messages"></div>
	                        <div class="controls">
	                            <div class="row">
	                                <div class="col-md-6">
	                                    <div class="form-group">
	                                        <label for="form_name" style="font-size:16px;">Firstname *</label>
	                                        <input id="form_name" type="text" name="name" class="form-control" placeholder="Firstname *" required="required" data-error="Firstname is required.">
	                                        <div class="help-block with-errors"></div>
	                                    </div>
	                                </div>
	                                <div class="col-md-6">
	                                    <div class="form-group">
	                                        <label for="form_lastname" style="font-size:16px;">Lastname *</label>
	                                        <input id="form_lastname" type="text" name="surname" class="form-control" placeholder="Lastname *" required="required" data-error="Lastname is required.">
	                                        <div class="help-block with-errors"></div>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="row">
	                                <div class="col-md-12">
	                                    <div class="form-group">
	                                        <label for="form_email" style="font-size:16px;">Email *</label>
	                                        <input id="form_email" type="email" name="email" class="form-control" placeholder="Email *" required="required" data-error="Valid email is required.">
	                                        <div class="help-block with-errors"></div>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="row">
	                                <div class="col-md-12">
	                                    <div class="form-group">
	                                        <label for="form_message" style="font-size:16px;">Message *</label>
	                                        <textarea id="form_message" name="message" class="form-control" placeholder="Your Message *" rows="4" required="required" data-error="Please,leave us a message." style="resize:none;height:200px;"></textarea>
	                                        <div class="help-block with-errors"></div>
	                                    </div>
	                                </div>
	                                <div class="col-md-12 col-lg-offset-5">
	                                    <input type="submit" class="btn btn-info btn-send btn-lg" value="Send">
	                                </div>
	                            </div>
	                        </div>
	                    </form>
	                </div>
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
