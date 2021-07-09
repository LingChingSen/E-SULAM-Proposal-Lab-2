<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$code = $_POST['code'];

$sqllogin = "SELECT * FROM tbl_seller WHERE seller_email = '$email' AND code = '$code'";
$result = $conn->query($sqllogin);

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
       
    }
}else{
    echo "failed";
}

?>