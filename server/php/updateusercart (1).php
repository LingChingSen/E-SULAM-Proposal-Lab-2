<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$prid = $_POST['prid'];
$op = $_POST['op'];
$qty = $_POST['qty'];

if ($op == "addcart") {
    $sqlupdateusercart = "UPDATE tbl_carts SET qty = qty +1 WHERE prid = '$prid' AND email = '$email'";
    if ($conn->query($sqlupdateusercart) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
}
if ($op == "removecart") {
    if ($qty == 1) {
        echo "failed";
    } else {
        $sqlupdateusercart = "UPDATE tbl_carts SET qty = qty - 1 WHERE prid = '$prid' AND email = '$email'";
        if ($conn->query($sqlupdateusercart) === TRUE) {
            echo "success";
        } else {
            echo "failed";
        }
    }
}
?>