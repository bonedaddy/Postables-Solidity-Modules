pragma solidity 0.4.18;

/** Built-in README
    
    * Developers    : Postables
    * Version       : 0.0.2alpha
    * Notes: Used for contract adminstration, and delegation of administrative duties 
**/

contract Administration {

    address     public owner;
    
    mapping (address => bool) public moderators;
    mapping (address => string) privilegeStatus;

    event AddMod(address indexed _invoker, address indexed _newMod, bool indexed _modAdded);
    event RemoveMod(address indexed _invoker, address indexed _removeMod, bool indexed _modRemoved);

    function Administration() public {
        owner = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == owner || moderators[msg.sender] == true);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner)
        public
        onlyOwner
        returns (bool success)
    {
        owner = _newOwner;
        return true;
        
    }

    function addModerator(address _newMod)
        public
        onlyOwner
        returns (bool added)
     {
        require(_newMod != address(0x0));
        moderators[_newMod] = true;
        AddMod(msg.sender, _newMod, true);
        return true;
    }
    
    function removeModerator(address _removeMod)
        public
        onlyOwner
        returns (bool removed)
    {
        require(_removeMod != address(0x0));
        moderators[_removeMod] = false;
        RemoveMod(msg.sender, _removeMod, true);
        return true;
    }

    function getRoleStatus(address _addr)
        public
        view  // We use view as we promise to not change state, but are reading from a state variable
        returns (string _role)
    {
        return privilegeStatus[_addr];
    }
}