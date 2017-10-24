pragma solidity 0.4.18;

/**
    * Author: Postables
    * Version: 0.0.1alpha;
    * Description: VERY basic random number generator
    *              
 */
import './SafeMath.sol';

contract RandomTest {
    using SafeMath for uint256;

    uint256 public randomNum;

    function generateRandomNumber(uint256 _max)
        public
        returns (bool _true)
    {
        randomNum = randomGen(uint256(uint(keccak256(msg.sender, block.number))), _max);
        return true;
    }
    function randomGen(uint256 _seed, uint256 _max)
        private
        view
        returns (uint256 randomNumber)
    {
        _max = _max.add(1);
        return uint(keccak256(block.blockhash(block.number-1), _seed ))%_max;
    }

}