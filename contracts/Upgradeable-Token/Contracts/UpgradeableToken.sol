pragma solidity 0.4.18;

import '../Token-Interfaces/ERC20Lib.sol';
import '../../../libraries/Math/SafeMath.sol';

contract UpgradeableToken is ERC20Advanced {
    using SafeMath for uint256;

    address[]  public burnFromAddresses;
    uint256 public totalSupply;
    uint8   public decimals;
    string  public name;
    string  public symbol;

    mapping (address => uint256) public balances;
    mapping (address => bool) public burnableAddress;
    mapping (address => mapping (address => uint256)) public allowed;

    struct PrivilegedBurnFromStruct {
        address burnFrom;
        mapping (address => bool) burnApproval;
        bool    enabled; //tracks whether this address is allowing burn froms
    }

   mapping (address => PrivilegedBurnFromStruct) public burnFromPrivileges; 

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
        returns (bool _transferred)
    {
        require(_amount > 0);
        require(balances[msg.sender] >= _amount);
        require(balances[msg.sender].sub(_amount) >= 0);
        require(balances[_receiver].add(_amount) > balances[_receiver]);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        return true;
    }

    function transferFrom(address _owner, address _recipient, uint256 _amount)
        public
        returns (bool _transferredFrom)
    {
        require(allowed[_owner][msg.sender] >= _amount);
        require(allowed[_owner][msg.sender].sub(_amount) >= 0);
        require(balances[_owner] >= _amount);
        require(balances[_owner].add(_amount) >= 0);
        require(balances[_recipient].add(_amount) > balances[_recipient]);
        balances[_owner] = balances[_owner].sub(_amount);
        balances[_recipient] = balances[_recipient].add(_amount);
        Transfer(_owner, _recipient, _amount);
        return true;
    }
    
    function approve(address _spender, uint256 _allowance)
        public
        returns (bool _approved)
    {
        require(_allowance > 0);
        require(allowed[msg.sender][_spender].add(_allowance) > allowed[msg.sender][_spender]);
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_allowance);
        Approval(msg.sender, _spender, _allowance);
        return true;
    }

    function allowanceIncrease(address _spender, uint256 _amountIncrease)
        public
        returns (bool _increased)
    {
        require(_amountIncrease > 0);
        require(allowed[msg.sender][_spender].add(_amountIncrease) > allowed[msg.sender][_spender]);
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_amountIncrease);
        return true;
    }

    function allowanceDecrease(address _spender, uint256 _amountDecrease)
        public
        returns (bool _decreased)
    {
        require(_amountDecrease > 0);
        require(allowed[msg.sender][_spender].sub(_amountDecrease) >= 0);
        allowed[msg.sender][_spender] = allowed[msg.sender][_spender].sub(_amountDecrease);
        return true;
    }

    function burn(uint256 _amountBurn)
        public
        returns (bool _burned)
    {
        require(_amountBurn > 0);
        require(balances[msg.sender] >= _amountBurn);
        require(balances[msg.sender].sub(_amountBurn) >= 0);
        balances[msg.sender] = balances[msg.sender].sub(_amountBurn);
        Transfer(msg.sender, 0, _amountBurn);
        return true;
    }
    
    function registerBurnAddress(address _burnAddress)
        public
        returns (bool _burnedFrom)
    {
        require(msg.sender == _burnAddress);
        burnFromPrivileges[_burnAddress].burnFrom = _burnAddress;
        burnFromPrivileges[_burnAddress].burnApproval[msg.sender] = true;
        burnFromPrivileges[_burnAddress].enabled = true;
        burnableAddress[_burnAddress] = true;
        burnFromAddresses.push(_burnAddress);
        return true;
    }

    function registerBurnAddressUser(address _burnAddress, address _user)
        public
        isBurnOwner
        returns (bool _burnedFrom)
    {
        require(msg.sender == _burnAddress);
        require(_user != address(0x0));
        burnFromPrivileges[_burnAddress].burnApproval[_user] = true;
        return true;
    }

    function deregisterBurnAddressUser(address _burnAddress, address _user)
        public
        isBurnOwner
        returns (bool _burned)
    {
        require(msg.sender == _burnAddress);
        require(msg.sender != _user);
        burnFromPrivileges[_burnAddress].burnApproval[_user] = false;
        return true;
    }

    function disableBurnFromAddress(address _burnAddress)
        public
        isBurnOwner
        returns (bool _burned)
    {
        require(msg.sender == _burnAddress);
        burnFromPrivileges[_burnAddress].enabled = false;
        return true;
    }

    function enableBurnFromAddress(address _burnAddress)
        public
        isBurnOwner
        returns (bool _burned)
    {
        require(msg.sender == _burnAddress);
        burnFromPrivileges[_burnAddress].enabled = true;
        return true; 
    }

    /// @notice msg.sender must be admin, must be allowed to burn from that desired address
    function burnFrom(address _burnFrom, uint256 _amountBurn)
        public
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
        returns (uint256 _balance);
    
    function totalSupply()
        public
        view
        returns (uint256 _totalSupply);
    
    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256 _allowance);
    
  
}