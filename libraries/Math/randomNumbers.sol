pragma solidity 0.4.18;

import "./SafeMath.sol";

/**
    A random number with increasing randomness and less predictability the more it is used.
*/

contract RandomNumberGenerator {
    using SafeMath for uint256;
    
    uint256     private    seed;
    bool        public      once;

    modifier onlyOnce() {
        require(!once);
        _;
    }

    function RandomNumberGenerator(uint256 _number, string _message) {
        seed = uint256(keccak256(msg.sender, keccak256(_message), _number, block.blockhash(block.number-1)));
    }
    
    function getRandomNumber(uint256 _max)
        public
        returns (uint256)
    {
        uint256 _number = generateRandomNumber(seed, _max);
        seed = calculateNewSeed(seed, _number);
        return _number;
    }

    function calculateNewSeed(uint256 _seed, uint256 _number)
        internal
        view
        returns (uint256)
    {
        return uint256(keccak256(_seed, _number,msg.sender,block.blockhash(block.number-1)));
    }

    function generateRandomNumber(uint256 _seed, uint256 _max)
        internal
        view
        returns (uint256)
    {
        _max = _max.add(1);
        // Uses the modulus operator to generate a sudo random number
        uint256 randomNumber = uint256(keccak256(block.blockhash(block.number-1), _seed, msg.sender))%_max;
        return randomNumber;
    }
}
