<?php
	ob_start();
	include 'db.php';
	$truckname = $_GET['deletemenu'];
	$menuname = $_GET['type'];


	deletesingleMenu($truckname, $menuname);

	header('Location: edit.php?edit=' . $truckname);

	ob_end_flush();
?>
