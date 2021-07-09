<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$address = $_GET['address'];
$pickuptime = $_GET['pickuptime'];


$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];

if ($paidstatus=="true"){
  $receiptid = $_GET['billplz']['id'];
  $signing = '';
    foreach ($data as $key => $value) {
        $signing.= 'billplz'.$key . $value;
        if ($key === 'paid') {
            break;
        } else {
            $signing .= '|';
        }
    }
    
     $sqlinsertpurchase = "INSERT INTO tbl_purchase(orderid,email,paid,status) VALUES('$receiptid','$userid', '$amount','paid')";
     $sqladd2 = "INSERT INTO tbl_order (email,prid,qty) 
                 SELECT email,prid, qty FROM tbl_carts
                 WHERE email='$userid'";
     $sqlinsertorder = "UPDATE tbl_order SET orderid = '$receiptid'WHERE orderid = '' and email = '$userid'";
     $sqlinsertorder2 = "UPDATE tbl_order SET address = '$address'WHERE address = '' and email = '$userid'";
     $sqlinserttotal = "UPDATE tbl_order SET total = '$amount'WHERE orderid = '$receiptid'";
     $sqladd3 = "INSERT INTO tbl_order2 (orderid,email,prid,qty,total) 
              SELECT orderid,email,prid, qty,total FROM tbl_order
              WHERE address = '' and email = '$userid'";
              $sqlinsertorder3 = "UPDATE tbl_order2 SET pickuptime = '$pickuptime'WHERE pickuptime = '' and email = '$userid' ";
    $sqldeleteorder = "DELETE FROM tbl_order WHERE address='' and email = '$userid'";
     $sqladd = "INSERT INTO tbl_tracking (email,prid,qty)
              SELECT email,prid, qty FROM tbl_carts
              WHERE email='$userid'";
  
   $sqlupdate = "UPDATE tbl_tracking SET orderid = '$receiptid' WHERE orderid = '' and email = '$userid'";
    $sqldeletecart = "DELETE FROM tbl_carts WHERE email='$userid'";
    
   
     $sqladd4 = "UPDATE tbl_dateorder SET No = '$userid'";
 
   
   $stmt = $conn->prepare($sqlinsertpurchase);
   $stmt->execute();
   $stmtadd2 = $conn->prepare($sqladd2);
   $stmtadd2->execute();
   $stmtorder = $conn->prepare($sqlinsertorder);
   $stmtorder->execute();
   $stmtorder2 = $conn->prepare($sqlinsertorder2);
   $stmtorder2->execute();
   $stmttotal = $conn->prepare($sqlinserttotal);
   $stmttotal->execute();
   $stmtadd3 = $conn->prepare($sqladd3);
   $stmtadd3->execute();
   $stmtorder3 = $conn->prepare($sqlinsertorder3);
   $stmtorder3->execute();
   $stmtdel2 = $conn->prepare($sqldeleteorder);
   $stmtdel2->execute();
   $stmtadd = $conn->prepare($sqladd);
   $stmtadd->execute();
   $stmtupdate = $conn->prepare($sqlupdate);
   $stmtupdate->execute();
   $stmtdel = $conn->prepare($sqldeletecart);
   $stmtdel->execute();
 
   $stmtadd4 = $conn->prepare($sqladd4);
   $stmtadd4->execute();
   
    
   
       echo '<br><br><body><div><h2><br><br><center>Your Receipt</center>
     </h1>
     <table border=1 width=80% align=center>
     <tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td>
     <td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr>
     <tr><td>Payment Status </td><td>'.$paidstatus.'
     </td></tr><td>Address </td><td> '.$address.'</td></tr><td>Pick Up Time </td><td> '.$pickuptime.'
     </td></tr>
     <tr><td>Date </td><td>'.date("d/m/Y").'</td></tr>
     <tr><td>Time </td><td>'.date("h:i a").'</td></tr>
     </table><br>
     <p><center>Press back button to return to your app</center></p></div></body>';
    
}
else{
     echo 'Payment Failed!';
     
}
?>