<?php
include_once("dbconnect.php");
$email = $_POST['email'];

$sqltracking = "SELECT * FROM tbl_tracking INNER JOIN tbl_products ON tbl_tracking.prid = tbl_products.prid WHERE tbl_tracking.email = '$email'";;

$result = $conn->query($sqltracking);

if ($result->num_rows > 0) {
    $products['cart'] = array();
    while ($row = $result->fetch_assoc()) {
        $productlist['orderid'] = $row['orderid'];
        $productlist['productId'] = $row['prid'];
        $productlist['productName'] = $row['prname'];
        $productlist['productType'] = $row['prtype'];
     
        $productlist['price'] = $row['prprice'];
        $productlist['cartqty'] = $row['qty'];
        $productlist['prqty'] = $row['prqty'];
       
        array_push($products['cart'], $productlist);
    }
    echo json_encode($products);
} else {
    echo "nodata";
}

?>