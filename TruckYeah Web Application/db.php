<?php
	$username = 'root';
	$password = 'truckyeahweb';
	$database = 'TruckYeah!';
	$host = 'localhost';

	$conn = new mysqli($host, $username, $password, $database);

	if ($conn->connect_error) {
		die("Connection failed: " . $conn->connect_error);
	}

	#some private funtions used for interact with db
	function query($query) {
		$conn = $GLOBALS['conn'];
		if ($conn->query($query) === TRUE) {
				// header("refresh:1; url=index.php");
				echo "<meta http-equiv='refresh' content='0; url=home.php'>";
		}
	}

	function queryInsert($query) {
		$conn = $GLOBALS['conn'];
		return $conn->query($query);
	}

	function queryRet($query) {
		$conn = $GLOBALS['conn'];
		$queryResult = $conn->query($query);
		return $queryResult->num_rows > 0 ? $queryResult->fetch_all(MYSQLI_ASSOC) : NULL;
	}

	// Insert Functions
	function insertNewUser($username, $email, $password) {
		$querystring = "INSERT INTO users ("
			. "username, "
			. "email, "
			. "password) "
			. "VALUES("
			. "'" . $username . "', "
			. "'" . $email . "', "
			. "'" . $password . "')";
		return queryInsert($querystring);
	}

	function insertNewfoodturk($username, $foodtruckname, $description) {
        $querystring = "INSERT INTO FoodTruck ("
            . "Username, "
            . "Name, "
            . "Description) "
            . "VALUES("
            . "'" . $username . "', "
            . "'" . $foodtruckname . "', "
            . "'" . $description . "')";
        return queryInsert($querystring);
    }

	function insertNewMenu($foodtruckname, $menuname, $menuprice) {
		$querystring = "INSERT INTO FoodTruckMenu ("
            . "Foodtruckname, "
            . "Name, "
            . "Price) "
            . "VALUES("
            . "'" . $foodtruckname . "', "
            . "'" . $menuname . "', "
            . "'" . $menuprice . "')";
        return queryInsert($querystring);
	}

	function insertImage($foodtruckname, $imagename, $image) {
		$querystring = "INSERT INTO FoodTruckImages ("
            . "Foodtruckname, "
			. "name, "
            . "image) "
            . "VALUES("
            . "'" . $foodtruckname . "', "
			. "'" . $imagename . "', "
            . "'" . $image . "')";
        return queryInsert($querystring);
	}

	// Select Functions
	function selectUser($username, $password) {
		$querystring = "SELECT * FROM users "
            . "WHERE "
            . "username='" . $username . "' "
            . "AND "
            . "password='" . $password . "'";
        return queryRet($querystring);
	}

	function selectFoodTrucks($username) {
        $querystring = "SELECT * FROM FoodTruck "
            . "WHERE "
            . "Username='" . $username . "'";
        return queryRet($querystring);
    }

	function selectFoodTruckMenu($truckname) {
		$querystring = "SELECT * FROM FoodTruckMenu "
            . "WHERE "
            . "Foodtruckname='" . $truckname . "'";
        return queryRet($querystring);
	}

	function selecttruck($truckname) {
		$querystring = "SELECT * FROM FoodTruck "
            . "WHERE "
            . "Name='" . $truckname . "'";
        return queryRet($querystring);
	}

	function selectImage($truckname) {
		$querystring = "SELECT * FROM FoodTruckImages "
            . "WHERE "
            . "Foodtruckname='" . $truckname . "'";
        return queryRet($querystring);
	}

	function selectAllImage() {
		$querystring = "SELECT * FROM FoodTruckImages";
        return queryRet($querystring);
	}

	// Delete Functions
	function deleteFoodTruck($truckname) {
		$querystring = "DELETE FROM FoodTruck "
			. "WHERE "
			. "Name='" . $truckname . "'";
		return query($querystring);
	}

	function deleteFoodTruckMenu($truckname) {
		$querystring = "DELETE FROM FoodTruckMenu "
			. "WHERE "
			. "Foodtruckname='" . $truckname . "'";
		return query($querystring);
	}

	function deleteFoodTruckImage($truckname) {
		$querystring = "DELETE FROM FoodTruckImages "
			. "WHERE "
			. "Foodtruckname='" . $truckname . "'";
		return query($querystring);
	}

	function deletesingleMenu($truckname, $menuname) {
		$querystring = "DELETE FROM FoodTruckMenu WHERE Foodtruckname='" . $truckname . "' AND Name='" . $menuname ."' ";
		return query($querystring);
	}

	// Update Functions
	function updateImagename($foodtruckname, $oldfoodtruckname) {
		$querystring = "UPDATE FoodTruckImages SET Foodtruckname='" . $foodtruckname . "' WHERE Foodtruckname='" . $oldfoodtruckname . "' ";
		return query($querystring);
	}
?>
