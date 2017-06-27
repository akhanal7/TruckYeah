<?php
	session_start();
	if($_SESSION['user'] == NULL) {
		header("location: login.php");
		exit;
	}
?>

<?php
	include "db.php";
	$emptyInput = FALSE;
	$alreadyexists = FALSE;
	$insertSuccesful = FALSE;

	if (isset($_POST['submit'])) {
		$username = "Pinto";
		$foodtruckname = $_POST['foodtruckname'];
        $description = $_POST['description'];
		$menuname = $_POST['name'];
		$menuprice = $_POST['price'];
		$number = count($_POST['name']);

		if (validateInputs($foodtruckname, $description, $menuname, $menuprice) === TRUE || validateImageInput()) {
			$emptyInput = TRUE;
		} else if (!insertNewfoodturk($username, $foodtruckname, $description)) {
			$alreadyexists = TRUE;
		} else {
			$image = addslashes(($_FILES['image']['tmp_name']));
			$imagename = addslashes(($_FILES['image']['name']));
			$image = file_get_contents($image);
			$image = base64_encode($image);
			insertImage($foodtruckname, $imagename, $image);
			insertNewfoodturk($username, $foodtruckname, $description);

			if ($number > 0) {
				for ($i = 0; $i < $number; $i++) {
					if (trim($_POST['name'][$i] != '')) {
						insertNewMenu($foodtruckname, $menuname[$i], $menuprice[$i]);
					}
				}
			}
			$insertSuccesful = TRUE;
		}
	}

	function validateInputs($foodtruckname, $description, $menuname, $menuprice) {
		if (empty($foodtruckname) || empty($description) || empty($menuname) || empty($menuprice)) {
			return TRUE;
		}
		return FALSE;
	}

	function validateImageInput() {
		if (!file_exists($_FILES['image']['tmp_name']) || !is_uploaded_file($_FILES['image']['tmp_name'])) {
			return TRUE;
		}
		return FALSE;
	}
?>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
        <title>Add Food Truck</title>
		<link rel="stylesheet" type="text/css" href="public/stylesheet/navbar.css">
        <link rel="stylesheet" type="text/css" href="public/stylesheet/newfoodtruck.css">
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
				<h1 class="header-heading"><span>Add a Food Truck</span></h1>
			</div>
		</div>

		<div  id="container">
			<div class="container inputlabel">
				<?php
					if ($emptyInput === TRUE) {
						echo '<p class="alert alert-danger" id="error">
								<strong>Every Field is required.</strong></p>';
					}
					if ($alreadyexists === TRUE) {
						echo '<p class="alert alert-danger" id="error">
								<strong>This food truck already exists.</strong></p>';
					}
					if ($insertSuccesful === TRUE) {
						echo '<p class="alert alert-success">
								<strong>Your food truck was successfully added.</strong></p>';
					}
				?>


				<form method="POST" name="add_name" id="add_name" enctype="multipart/form-data">
						<div class="form-group">
							<label>Food Truck Name</label>
							<input type="text" autofocus="autofocus" placeholder="Food Truck's Name" class="form-control" name="foodtruckname"/>
						</div>
						<div class="form-group">
							<label>Description</label>
							<textarea class="form-control" placeholder="Description" id="foodtruckdesc" name="description"></textarea>
						</div>

						<h1 style="text-align:center;">Add Menu Items</h1>
						<hr style="margin-bottom:30px;width: 300px;height: 2px;background-color: rgba(45, 45, 45, 0.15);">

						<div class="form-group" id="dynamic_field">
							<label>Menu Name</label>
							<input type="text" name="name[]" placeholder="Enter Menu Name" class="form-control name_list" id="menuname" />
							<label>Price</label>
							<input type="text" name="price[]" placeholder="Enter Price" class="form-control name_list" id="menuprice" />
							<a class="btn btn-xs" type="button" name="add" id="add"><i class="fa fa-plus-circle fa-3x plusicon" aria-hidden="true" id="addmenu"></i></a>
			            </div>

						<div class="form-group">
							<label style="margin-right:10px;">Upload an Image</label>
							<label class="input-group-btn">
								<span class="btn btn-primary">
								  Browse&hellip; <input type="file" id="myfile" name="image" style="display: none;" onchange="document.getElementById('output').src = window.URL.createObjectURL(this.files[0])"/>
							  </span>
							</label>
							<img id="output" width="350px" height="250px" src="https://img.clipartfox.com/547e74b96892ab7fb2f98c444837f28f_the-white-table-gallery-images-white_1200-630.jpeg" style="margin-left:90px"/>
						</div>
						<br />
						<button type="submit" name="submit" id="submit" class="btn btn-info">Submit</button>
				</form>
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

<script type="text/javascript">
$(document).ready(function() {
	  var i = 1;
	  var start = 1;
	  var maxNum = 10;
	  var newInputfield = '<div id="row' + i + '"><label>Menu Name</label> <input type="text" name="name[]" placeholder="Enter Menu Name" class="form-control name_list" id="menuname" />  <label>Price</label> <input type="text" name="price[]" placeholder="Enter Price" class="form-control name_list" id="menuprice" />  <a class="btn btn-xs btn_remove" type="button" name="remove" id="' + i + '"><i id="removemenu" class="fa fa-minus-circle fa-3x plusicon" aria-hidden="true"></i></a></div>';

	  $('#add').click(function() {
		   i++;
		   if (start <= maxNum) {
			   $('#dynamic_field').append(newInputfield);
			   start++;
		   }
	  });
	  $(document).on('click', '.btn_remove', function() {
		   var button_id = $(this).attr("id");
		   $('#row' + button_id + '').remove();
		   start--;
	  });
	  $('#submit').click(function(){
		   $.ajax({
				url: "newfoodtruck.php",
				method: "POST",
				data: $('#add_name').serialize(),
				success: function(data)
				{
					 $('#add_name')[0].reset();
				}
		   });
	  });
 });
</script>
