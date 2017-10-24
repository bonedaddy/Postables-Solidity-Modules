pragma solidity 0.4.18;

/**
    * Author: Postables
    * Version: 0.0.1alpha;
    * Description: VERY basic random number generator
    *              
 */

 // @dev Import safemath
import './SafeMath.sol';

contract RandomTest {
    using SafeMath for uint256;

    uint256 public randomNum;

    /// @dev Calls the random number generator
    /// @param _max This is the number to use as the limit
    function generateRandomNumber(uint256 _max)
        public
        returns (bool _true)
    {
        // Assign "random" number
        // Generate a "seed"
        randomNum = randomGen(uint256(uint(keccak256(msg.sender, block.number, msg.sig, msg.gas))), _max);
        return true;
    }
    function randomGen(uint256 _seed, uint256 _max)
        private
        view
        returns (uint256 randomNumber)
    {
        _max = _max.add(1);
        // Uses the modulus operator to generate a sudo random number
        return uint(keccak256(block.blockhash(block.number-1), _seed ))%_max;
    }

    function getRandomNumber()
        public
        view
        returns (uint256 randomNumber)
    {
        return randomNum;
    }
}