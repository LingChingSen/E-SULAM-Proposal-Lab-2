<?php
include_once("dbconnect.php");
$email = $_POST['email'];

$sqlorder = "SELECT * FROM tbl_order INNER JOIN tbl_products ON tbl_order.prid = tbl_products.prid ";;

$result = $conn->query($sqlorder);

if ($result->num_rows > 0) {
    $products['cart'] = array();
    while ($row = $result->fetch_assoc()) {
         $productlist['dateorder'] = $row['dateorder'];
        $productlist['orderid'] = $row['orderid'];
        $productlist['address'] = $row['address'];
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