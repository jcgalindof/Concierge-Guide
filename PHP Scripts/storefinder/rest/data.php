<?php

  require '../header_rest.php';
  $controllerRest = new ControllerRest();

  $resultPhotos = $controllerRest->getResultPhotos();
  $resultCategories = $controllerRest->getResultCategories();
  $resultStores = $controllerRest->getResultStores();

  header ("content-type: text/json");
  // header("Content-Type: application/text; charset=ISO-8859-1");
  echo "{";

            // PHOTOS
            echo "\"photos\" : [";
            $no_of_rows = $resultPhotos->rowCount();
            $ind = 0;
            $count = $resultPhotos->columnCount();
            foreach ($resultPhotos as $row) 
            {
                echo "{";
                $inner_ind = 0;
                foreach ($row as $columnName => $field) 
                {

                    $val = trim(strip_tags($field));
                    if(!is_numeric($columnName)) {
                        echo "\"$columnName\" : \"$val\"";

                        if($inner_ind < $count - 1)
                          echo ",";

                        ++$inner_ind;
                    }
                }

                if($count > $inner_ind) {
                    echo "\"slug\" : \"slug\"";
                }

                echo "}";

                if($ind < $no_of_rows - 1)
                  echo ",";

                ++$ind;
            }
            echo "], ";

            // CATEGORIES
            echo "\"categories\" : [";
            $no_of_rows = $resultCategories->rowCount();
            $ind = 0;
            $count = $resultCategories->columnCount();
            foreach ($resultCategories as $row) 
            {
                echo "{";
                $inner_ind = 0;
                foreach ($row as $columnName => $field) 
                {

                    $val = trim(strip_tags($field));
                    if(!is_numeric($columnName)) {
                        echo "\"$columnName\" : \"$val\"";

                        if($inner_ind < $count - 1)
                          echo ",";

                        ++$inner_ind;
                    }
                }

                if($count > $inner_ind) {
                    echo "\"slug\" : \"slug\"";
                }

                echo "}";

                if($ind < $no_of_rows - 1)
                  echo ",";

                ++$ind;
            }
            echo "], ";


            // STORES
            echo "\"stores\" : [";
            $no_of_rows = $resultStores->rowCount();
            $ind = 0;
            $count = $resultStores->columnCount();
            foreach ($resultStores as $row) 
            {
                echo "{";
                $inner_ind = 0;
                foreach ($row as $columnName => $field) 
                {

                    $val = trim(strip_tags($field));

                    if($columnName == "store_desc") {
                        $val1 = preg_replace('~[\r\n]+~', '', $val);
                        $val = htmlspecialchars(trim(strip_tags($val1)));
                    }
                    
                    if(!is_numeric($columnName)) {
                        echo "\"$columnName\" : \"$val\"";

                        if($inner_ind < $count - 1)
                          echo ",";

                        ++$inner_ind;
                    }
                }

                if($count > $inner_ind) {
                    echo "\"slug\" : \"slug\"";
                }

                echo "}";

                if($ind < $no_of_rows - 1)
                  echo ",";

                ++$ind;
            }
            echo "] ";
       
  echo "}";
?>