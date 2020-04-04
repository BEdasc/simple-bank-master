pragma solidity >=0.5.0 <0.7.0;

contract SimpleBank {

    event LogEnrolled(address indexed accountAddress);
    event LogDepositMade(address indexed accountAddress, uint amount);
    event LogWithdrawal(address indexed accountAddress, uint withdrawAmount, uint newBalance);

    mapping (address => uint) private balances;
    mapping (address => bool) public enrolled;

    address public owner;

    constructor() public {
    owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() external payable {
        revert("Something goes wrong!");
    }

    /// @notice Get balance
    /// @return The balance of the user

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status

    function enroll() public returns (bool){
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made

    function deposit() public payable returns (uint) {
        require(enrolled[msg.sender]);
        balances[msg.sender] += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user

    function withdraw(uint withdrawAmount) public returns (uint) {
        require(withdrawAmount <= balances[msg.sender]);
        balances[msg.sender] -= withdrawAmount;
        msg.sender.transfer(withdrawAmount);
        uint balanceClient = balances[msg.sender];
        emit LogWithdrawal(msg.sender, withdrawAmount, balanceClient);
        return balanceClient;
    }

}
