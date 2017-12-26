pragma solidity 0.4.19;

import "./SafeMath.sol";

/**
    [Title]         Random Number Generator library
    [Author]        Postables
    [Description]   Library RNG contract, reusable seed pseudo-randomized upon usage.
*/

contract RandomNumberGenerator {
    using SafeMath for uint256;
    uint256 private seed;

    function RandomNumberGenerator(string _msg, uint256 _number) {
        seed = uint256(keccak256(_msg, msg.gas, tx.gasprice, msg.sender, _number));
    }

    function getRandomNumber(uint256 _max)
        public
        returns (uint256)
    {
        uint256 _number = generateRandomNumber(seed, _max);
        require(calculateNewSeed(_max, _number));
        return _number;
    }

    function calculateNewSeed(uint256 _max, uint256 _number)
        internal
        returns (bool)
    {
        seed = uint256(keccak256(_max, _number, msg.gas, tx.gasprice, msg.sender));
        return true;
    }

    function generateRandomNumber(uint256 _seed, uint256 _max)
        internal
        view
        returns (uint256)
    {
        _max = _max.add(1);
        // Uses the modulus operator to generate a sudo random number
        uint256 randomNumber = uint256(keccak256(tx.gasprice, msg.gas, _seed, msg.sender))%_max;
        return randomNumber;
    }
}
