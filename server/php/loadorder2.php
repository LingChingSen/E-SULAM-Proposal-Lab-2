<?php
include_once("dbconnect.php");
$email = $_POST['email'];

$sqlorder = "SELECT * FROM tbl_order2 INNER JOIN tbl_products ON tbl_order2.prid = tbl_products.prid ";;

$result = $conn->query($sqlorder);

if ($result->num_rows > 0) {
    $products['cart'] = array();
    while ($row = $result->fetch_assoc()) {
         $productlist['dateorder'] = $row['dateorder'];
        $productlist['orderid'] = $row['orderid'];
        $productlist['pickuptime'] = $row['pickuptime'];
        $productlist['total'] = $row['total'];
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