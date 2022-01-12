// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


contract celoVote {

    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    using SafeMath for uint;

    uint internal argumentsLength = 0;
    // setting the agreement price to 1 cusd
    uint agreementprice = 1000000000000000000;

    address _contractOwner;

// Declaring struct with all the arguments properties
    struct Arguments {
        address payable owner;
        string topic;
        string arg1;
        string arg2;
        uint arg1votes;
        uint arg2votes;
    }

    // mapping each struct with an index of type uint
    mapping (uint => Arguments) internal arguments;


// constructor for setting the ownership of the contract to the creator of the contract
    constructor() {
        _contractOwner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == _contractOwner);
        _;
    }

// Add a new topic and arguments to the celo block - chain
   function addArgument(
		string memory _topic,
		string memory _arg1,
		string memory _arg2 
	) public {
		uint _arg1votes = 0;
        uint _arg2votes = 0;
		arguments[argumentsLength] = Arguments(
			payable(msg.sender),
			_topic,
			_arg1,
			_arg2,
            _arg1votes,
            _arg2votes
		);
    
        argumentsLength++; // increasing the length of the total topics after adding a new topic and arguments to the celo block-chain
	}


    // function to edith argument
    function editArgument(
        uint256 _index,
        string memory _topic,
		string memory _arg1,
		string memory _arg2 
    ) public {
        require(msg.sender == arguments[_index].owner, "Only creator of argument can edit");
        uint _arg1votes = arguments[_index].arg1votes;
        uint _arg2votes = arguments[_index].arg2votes;
        arguments[_index] = Arguments(
            payable(msg.sender),
			_topic,
			_arg1,
			_arg2,
            _arg1votes,
            _arg2votes
        );
    }


    // reading the arguments from the celo block chain
    function readArguments(uint _index) public view returns (
            address payable,
            string memory, 
            string memory, 
            string memory, 
            uint, 
            uint
        ) {
		return (
			arguments[_index].owner, 
			arguments[_index].topic, 
			arguments[_index].arg1, 
			arguments[_index].arg2,  
			arguments[_index].arg1votes,
			arguments[_index].arg2votes
		);
	}


    // function to vote for argument by paying in cUsd
    function voteArgument(uint _index, uint arg_num, uint _amount) public payable  {
        require(_amount == agreementprice);
        
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
            msg.sender,
            arguments[_index].owner,
            _amount
          ),
          "Transfer failed."
        );

        if (arg_num == 1)   arguments[_index].arg1votes++; // increasing the votes for arg 1
        if (arg_num == 2)   arguments[_index].arg2votes++; // increasing the votes for arg 2
        
    }

    // function to return the length of topics with arguments
    function getargumentsLength() public view returns (uint) {
        return (argumentsLength);
    }
    

    // function to modify the agreement price
    function modify_agreement_price(uint new_cost) public onlyOwner{
        agreementprice = new_cost;
    }
  
}