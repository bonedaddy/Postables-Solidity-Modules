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
    mapping (address => mapping (address => uint256)) public allowed;

    struct PrivilegedBurnFromStruct {
        address burnFrom;
        mapping (address => bool) burnApproval;
        bool    enabled; //tracks whether this address is allowing burn froms
    }

    PrivilegedBurnFromStruct[] public burnFromStruct;

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
    
    
    /// @notice msg.sender must be admin, must be allowed to burn from that desired address
    function burnFrom(address _burnFrom, uint256 _amountBurn)
        public
        returns (bool _burnedFrom);
    
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