pragma solidity 0.4.18;


library SafeMathInt {

  function mul(int256 a, int256 b) internal pure returns (int256) {
    int256 c = a * b;
    require(a == 0 || c / a == b);
    return c;
  }

  function div(int256 a, int256 b) internal pure returns (int256) {
    int256 c = a / b;
    return c;
  }

  function sub(int256 a, int256 b) internal pure returns (int256) {
    require(b <= a);
    return a - b;
  }

  function add(int256 a, int256 b) internal pure returns (int256) {
    int256 c = a + b;
    require(c >= a);
    return c;
  }
}