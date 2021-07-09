<?php

include_once("dbconnect.php");

$user_email = $_POST['email'];
$newusername = $_POST['newusername'];
$newphonenum = $_POST['newphonenum'];

$sql = "SELECT * FROM tbl_user WHERE user_email = '$user_email'";
$result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $sqlupdate = "UPDATE tbl_user SET username = '$newusername', phonenum = '$newphonenum' WHERE user_email = '$user_email'";
        if ($conn->query($sqlupdate) === TRUE){
                
                echo 'success';
        }else{
                echo 'failed';
        }
    }else{
        echo "failed";
    }

?>