<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$prid = $_POST['prid'];
$orderid = $_POST['orderid'];

 $sqladd = "INSERT INTO tbl_history (email,prid,qty,datepurchase)
              SELECT email,prid, qty,datepurchase FROM tbl_tracking
              WHERE email='$email'";
$sqldelete = "DELETE FROM tbl_tracking WHERE email='$email'AND orderid='$orderid' AND prid = '$prid'";

              
$stmtadd = $conn->prepare($sqladd);
   $stmtadd->execute();
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>