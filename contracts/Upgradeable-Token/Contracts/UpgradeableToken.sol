pragma solidity 0.4.18;

import '../Token-Interfaces/ERC20Lib.sol';
import '../../../libraries/Math/SafeMath.sol';

contract UpgradeableToken is ERC20Advanced {
    using SafeMath for uint256;

    uint256 public totalSupply;
    uint8   public decimals;
    string  public name;
    string  public symbol;

    mapping (address => uint256) public balances;
    mapping (address => uint256) public allowed;

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
    

    
}