pragma solidity 0.4.18;

import '../Token-Interfaces/ERC20Lib.sol';
import '../../Administration.sol';
import '../../SafetyControls.sol';
import '../../../libraries/Math/SafeMath.sol';

contract Token is Administration, SafetyControls {
    using SafeMath for uint256;

    address[]  public burnFromAddresses;
    uint256 public totalSupply;
    uint8   public decimals;
    string  public name;
    string  public symbol;
    ERC20Advanced public token;
    mapping (address => uint256) public balances;
    mapping (address => bool) public burnableAddress;
    mapping (address => mapping (address => uint256)) public allowed;

    struct PrivilegedBurnFromStruct {
        address burnFrom;
        mapping (address => bool) burnApproval;
        bool    enabled; //tracks whether this address is allowing burn froms
    }

   mapping (address => PrivilegedBurnFromStruct) public burnFromPrivileges; 

    event Transfer(address indexed _sender, address indexed _recipient, uint256 _uint256);
    event Approval(address indexed _owner, address indexed _spender, uint256 _allowed);
    modifier isBurnOwner() {
        for (uint256 i = 0; i < burnFromAddresses.length; i++) {
            if (msg.sender == burnFromAddresses[i]) {
                _;
            }
        }
    }

    function UpgradeableToken(uint256 _totalSupply, uint8 _decimals, string _name, string _symbol) public {
        totalSupply = _totalSupply;
        decimals = _decimals;
        name = _name;
        symbol = _symbol;
        balances[msg.sender] = _totalSupply;
    }

    function transfer(address _receiver, uint256 _amount)
        public
        isRunning
        returns (bool _transferred)
    {
        token.transfer(_receiver, _amount);
        return true;
    }

    function transferFrom(address _owner, address _recipient, uint256 _amount)
        public
        isRunning
        returns (bool _transferredFrom)
    {
        token.transferFrom(_owner, _recipient, _amount);
        return true;
    }
    
    function approve(address _spender, uint256 _allowance)
        public
        isRunning
        returns (bool _approved)
    {
        token.approve(_spender, _allowance);
        return true;
    }

    function allowanceIncrease(address _spender, uint256 _amountIncrease)
        public
        isRunning
        returns (bool _increased)
    {
        token.allowanceIncrease(_spender, _amountIncrease);
        return true;
    }

    function allowanceDecrease(address _spender, uint256 _amountDecrease)
        public
        isRunning
        returns (bool _decreased)
    {
        token.allowanceDecrease(_spender, _amountDecrease);
        return true;
    }

    function burn(uint256 _amountBurn)
        public
        isAdmin
        isRunning
        returns (bool _burned)
    {
        token.burn(_amountBurn);
        return true;
    }
    
    function registerBurnAddress(address _burnAddress)
        public
        isAdmin
        isRunning
        returns (bool _burnedFrom)
    {
        token.registerBurnAddress(_burnAddress);
        return true;
    }

    function registerBurnAddressUser(address _burnAddress, address _user)
        public
        isAdmin
        isBurnOwner
        isRunning
        returns (bool _burnedFrom)
    {
        token.registerBurnAddressUser(_burnAddress, _user);
        return true;
    }

    function deregisterBurnAddressUser(address _burnAddress, address _user)
        public
        isAdmin
        isBurnOwner
        isRunning
        returns (bool _burned)
    {
        token.deregisterBurnAddressUser(_burnAddress, _user);
        return true;
    }

    function disableBurnFromAddress(address _burnAddress)
        public
        isAdmin
        isBurnOwner
        isRunning
        returns (bool _burned)
    {
        token.disableBurnFromAddress(_burnAddress);
        return true;
    }

    function enableBurnFromAddress(address _burnAddress)
        public
        isAdmin
        isBurnOwner
        isRunning
        returns (bool _burned)
    {
        require(msg.sender == _burnAddress);
        burnFromPrivileges[_burnAddress].enabled = true;
        return true; 
    }

    /// @notice msg.sender must be admin, must be allowed to burn from that desired address
    function burnFrom(address _burnFrom, uint256 _amountBurn)
        public
        isAdmin
        isRunning
        returns (bool _burnedFrom)
    {
        require(_amountBurn > 0);
        require(burnableAddress[_burnFrom]);
        require(burnFromPrivileges[_burnFrom].enabled);
        require(burnFromPrivileges[_burnFrom].burnApproval[msg.sender]);
        require(balances[_burnFrom].sub(_amountBurn) >= 0);
        require(totalSupply.sub(_amountBurn) >= 0);
        balances[_burnFrom] = balances[_burnFrom].sub(_amountBurn);
        totalSupply = totalSupply.sub(_amountBurn);
        return true;
    }
    
    //GETTERS//

    function balanceOf(address _addr)
        public
        view
        returns (uint256 _balance)
    {
        return balances[_addr];
    }
    
    function totalSupply()
        public
        view
        returns (uint256 _totalSupply)
    {
        return totalSupply;
    }
    
    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 _allowance)
    {
        return allowed[_owner][_spender];
    }
    

}