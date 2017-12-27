pragma solidity 0.4.19;

import "./SafeMath.sol";

/**
    [Title]         Random Number Generator library
    [Author]        Postables
    [Description]   Library RNG contract, no reusable seed.
    [Warnings]      Do not use in contracts for which the outcome of the prng would give someone an advantage over someone else
                    -> lottery contracts, roulette, gambling contracts, and so on.
*/

library RandomNumberGeneratorLib {
    using SafeMath for uint256;

    function getRandomNumber(uint256 _seed, uint256 _max)
        public
        view
        returns (uint256)
    {
        uint256 _number = generateRandomNumber(_seed, _max);
        return _number;
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
