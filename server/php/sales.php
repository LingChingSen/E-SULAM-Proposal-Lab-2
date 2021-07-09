<?php

include_once("dbconnect.php");

$sqldelete = "DELETE FROM tbl_orderhistory";
$stmtdelete = $conn->prepare($sqldelete);
   $stmtdelete->execute();
$date = $_POST['date'];
$sales = $_POST['sales'];

$sqlsales = "INSERT INTO tbl_sales(date,sales) VALUES('$date','$sales')";
if($conn->query($sqlsales) === TRUE){
    echo "success";
}else{
    echo "failed";
}

?>