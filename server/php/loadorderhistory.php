<?php
include_once("dbconnect.php");
$email = $_POST['email'];
$dateorder = $_POST['dateorder'];

$sqlhistory = "SELECT * FROM tbl_orderhistory INNER JOIN tbl_products ON tbl_orderhistory.prid = tbl_products.prid ";;

$result = $conn->query($sqlhistory);

if ($result->num_rows > 0) {
    $products['cart'] = array();
    while ($row = $result->fetch_assoc()) {
         $productlist['total'] = $row['total'];
        $productlist['dateorder'] = $row['dateorder'];
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