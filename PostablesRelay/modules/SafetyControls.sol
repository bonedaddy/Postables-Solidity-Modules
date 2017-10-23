pragma solidity 0.4.18;

import './Administration.sol';

contract SafetyControls is Administration {

    bool public operationsPaused;

    event PauseOperation(address indexed _invoker, bool indexed _paused);
    event ResumeOperation(address indexed _invoker, bool indexed _resumed);

    modifier isRunning() {
        require(!operationsPaused);
        _;
    }
    
    function SafetyControls() public {
        operationsPaused = true;
    }

    function pauseOperation()
        public
        onlyAdmin
        returns (bool _paused)
    {
        require(!operationsPaused);
        operationsPaused = true;
        PauseOperation(msg.sender, true);
        return true;
    }
    
    function resumeOperation()
        public
        onlyAdmin
        returns (bool _resumed)
    {
        require(operationsPaused);
        operationsPaused = false;
        ResumeOperation(msg.sender, true);
        return true;
    }

}