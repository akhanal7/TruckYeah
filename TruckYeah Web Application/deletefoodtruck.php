<?php
	include 'db.php';
	$truckname = $_GET['delete'];

	deleteFoodTruckMenu($truckname);
	deleteFoodTruckImage($truckname);
	deleteFoodTruck($truckname);
?>
