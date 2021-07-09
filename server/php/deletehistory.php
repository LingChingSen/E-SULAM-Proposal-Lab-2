<?php
include_once("dbconnect.php");
$email = $_POST['email'];


$sqldelete = "DELETE FROM tbl_history WHERE email='$email'";
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>