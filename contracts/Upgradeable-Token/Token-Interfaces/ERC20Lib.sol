pragma solidity 0.4.18;

interface ERC20Advanced {

    event Transfer(address indexed _sender, address indexed _recipient, uint256 amount); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _amount);

    function transfer(address _recipient, uint256 _amount)
        public
        returns (bool _transferred);

    function transferFrom(address _owner, address _recipient, uint256 _amount)
        public
        returns (bool _transferredFrom);
    
    function approve(address _spender, uint256 _allowance)
        public
        returns (bool _approved);

    function allowanceIncrease(address _spender, uint256 _amountIncrease)
        public
        returns (bool _increased);

    function allowanceDecrease(address _spender, uint256 _amountDecrease)
        public
        returns (bool _decreased);
        
    function burn(uint256 _amountBurn)
        public
        returns (bool _burned);
    
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