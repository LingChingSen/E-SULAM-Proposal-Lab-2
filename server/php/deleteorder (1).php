<?php
include_once("dbconnect.php");
$orderid = $_POST['orderid'];
$prid = $_POST['prid'];

 $sqladd = "INSERT INTO tbl_orderhistory (orderid,prid,qty,dateorder,total)
              SELECT orderid,prid, qty,dateorder,total FROM tbl_order
              WHERE orderid='$orderid'AND prid = '$prid'";
$sqldelete = "DELETE FROM tbl_order WHERE orderid='$orderid' AND prid = '$prid'";

              
$stmtadd = $conn->prepare($sqladd);
   $stmtadd->execute();
$stmt = $conn->prepare($sqldelete);
if ($stmt->execute()) {
    echo "success";
} else {
    echo "failed";
}
?>