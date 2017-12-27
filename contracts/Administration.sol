pragma solidity 0.4.18;



contract Administration {

    address     public  owner;
    address     public  administrator;
    bool        public  administrationContractFrozen;

    mapping (address => bool) public moderators;

    event ModeratorAdded(address indexed _invoker, address indexed _newMod, bool indexed _newModAdded);
    event ModeratorRemoved(address indexed _invoker, address indexed _removeMod, bool indexed _modRemoved);
    event SetAdministrator(address indexed _invoker, address indexed _newAdmin, bool indexed _newAdminAdded);

    function Administration() {
        owner = msg.sender;
        administrator = msg.sender;
        administrationContractFrozen = false;
    }

    modifier notFrozen() {
        require(!administrationContractFrozen);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == owner || msg.sender == administrator);
        _;
    }

    modifier onlyModerator() {
        if (msg.sender == owner) {_;}
        if (msg.sender == administrator) {_;}
        if (moderators[msg.sender]) {_;}
    }

    function freezeAdministrationContract() public onlyAdmin returns (bool frozen) {
        administrationContractFrozen = true;
        return true;
    }

    function addModerator(address _newMod) public onlyAdmin notFrozen returns (bool success) {
        moderators[_newMod] = true;
        ModeratorAdded(msg.sender, _newMod, true);
        return true;
    }

    function removeModerator(address _removeMod) public onlyAdmin notFrozen returns (bool success) {
        moderators[_removeMod] = false;
        ModeratorRemoved(msg.sender, _removeMod, true);
        return true;
    }

    function setAdministrator(address _administrator) public onlyOwner notFrozen returns (bool success) {
        administrator = _administrator;
        SetAdministrator(msg.sender, _administrator, true);
        return true;
    }
    function transferOwnership(address _newOwner) public onlyOwner notFrozen returns (bool success) {
        owner = _newOwner;
        return true;
    }
}