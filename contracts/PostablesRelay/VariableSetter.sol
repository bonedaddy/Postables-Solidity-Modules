pragma solidity 0.4.18;

import './modules/SafeMath.sol';
import './modules/Administration.sol';
import './modules/SafetyControls.sol';

contract VariableSetter is SafetyControls {
    using SafeMath for uint256;

    uint256 public intStore;
    bool    public contractLaunched;

    modifier preLaunch() {
        require(!contractLaunched);
        _;
    }

    function VariableSetter() public {
        contractLaunched = false;
    }

    function launchContract()
        public
        preLaunch
        onlyAdmin
        returns (bool _launched)
    {
        operationsPaused = false;
        contractLaunched = true;
        return true;
    }

    function setInt(uint256 _newInt)
        public
        isRunning
        returns (bool _set)
    {
        intStore = _newInt;
        return true;
    }

    function getIntStore()
        public
        constant
        returns (uint256 _intStore)
    {
        return intStore;
    }
}