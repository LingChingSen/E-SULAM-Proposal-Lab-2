<?php
include_once("dbconnect.php");

$prid = $_POST['prid'];

$sqldelete = "DELETE FROM tbl_products WHERE prid = '$prid'";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>