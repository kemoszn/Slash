pragma solidity^0.4.17;

contract Events {
    address[] private deployedEvents;

    function createEvent(string _eventName, string _homeCurrency) public {
        address newEvent = new Event(msg.sender, _eventName, _homeCurrency);
        deployedEvents.push(newEvent);
    }

    function getEvents() public view returns (address[]) {
        return deployedEvents;
    }
}


contract Event {
    string public eventName;
    string public homeCurrency;
    mapping (address => bool) public participants;
    address[] public verifiedParticipants;
    uint public participantsCount;
    address public manager;
    //address[] private deployedExpenses;
    Expense[] public expenses;
    /*
    struct Fees {
        uint amount;
        bool is_settled;
    }
    */

    struct Expense {
        address owner;
        uint totalCost;
        string description;
        bool splitEqually;
        mapping(address => uint) dues;
    }

    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
     //constructor function
     function Event(address creator, string _eventName, string _homeCurrency) public {
        manager = creator;
        eventName = _eventName;
        homeCurrency = _homeCurrency;
        participantsCount = 0;
        setParticipants(creator, true);
        //participantsCount = participants.length;
    }

    function setParticipants (address _address, bool _bool) public restricted{
        participants[_address] = _bool;
        participantsCount++;

    }

    function createExpense(uint totalCost, string description, bool splitEqually) public  {
        Expense memory newExpense = Expense({
            owner: msg.sender,
            totalCost: totalCost,
            description: description,
            splitEqually: splitEqually

        });
        newExpense.owner = msg.sender;
        expenses.push(newExpense);
    }

    function approveParticipant() public {
        if (!participants[msg.sender]) {
            participants[msg.sender] = true;
            verifiedParticipants.push(msg.sender);
        }
    }


    function setDues (uint index) public {
        Expense storage expense = expenses[index];
        for (uint i=0; i<participantsCount; i++) {
         expense.dues[verifiedParticipants[i]] = expense.totalCost/participantsCount;
        }

    }

    /*
    function calculateDues(uint index) payable {
        Expense storage expense = expenses[index];
        require (participants[msg.sender]); //make sure that they're participants who approved
        if (expense.splitEqually) {
            require (msg.value > totalCost/participantsCount) //make sure they have substanial money
            msg.value = totalCost/participantsCount;
            dues[msg.sender] += msg.value; //append to dues
        } else {

        }

    }
    */


    function getExpensesLength() public view returns (uint) {
        return expenses.length;
    }



}
