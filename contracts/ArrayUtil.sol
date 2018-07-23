pragma solidity ^0.4.23;

library ArrayUtil {

    function contains(address [] array, address key) returns (bool) {
        for (uint i = 0; i < array.length; i++){
            if(array[i] == key){
                return true;
            }
        }
        return false;
    }

}
