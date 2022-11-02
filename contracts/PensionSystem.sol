// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract PensionSystem{
    Schemess[] national;
    Schemess[] state;
    Schemess[] district;

    constructor() {
        national.push(Schemess("N001", "National Level Pension Scheme", 50000, 60));
        state.push(Schemess("S001", "State Level Pension Scheme", 49999, 60));
        district.push(Schemess("D001", "District Level Pension Scheme", 49888, 60));
    }
    
    struct Date{
        uint day;
        uint month;
        uint year;
    }

    // struct Scheme{
    //     string scheme_id;
    //     string scheme_name;
    //     uint256 amount;
    //     uint256 eligibleAge;
    // }
    struct Schemess{
        string scheme_id;
        string scheme_name;
        uint256 amount;
        uint256 eligibleAge;
    }

    // mapping(uint => SchemeDetails) scheme;

    struct SchemeDetails{
        string classification;
        Schemess scheme;
        Date lastRenewed;
        Date applied;
        Date firstReceived;
    }

    struct User{
        string name;
        Date dob;
        address emp_id;
        string sal_id;
        string public_id;
        uint[] schemeIds;
        bool isPresent;
    }

    bool transactionStatus = false;

    mapping(address => User) users;
    mapping(address => uint) userPresent;
    mapping(string => Schemess) schemeIdSchemes;
    mapping(address => SchemeDetails[]) userSchemeDetails;


    address[] userIds;
    // mapping(string => SchemeDetails[]) scheme;

    // Schemess[] national = [Schemess("N001", "National Level Pension Scheme", 50000, 60)];
    // Schemess[] state = [Schemess("S001", "State Level Pension Scheme", 49999, 60)];
    // Schemess[] district = [Schemess("D001", "District Level Pension Scheme", 49888, 60)];


    event userAdded(address[] userIds);
    event userRenewed(string emp_id, string scheme_id, string scheme_name);

    // Getters 
    function getTransactionStatus() public view returns (bool){
        return transactionStatus;
    }

    function getSchemes(string memory classification) public view returns(Schemess[] memory ){
        if(keccak256(abi.encodePacked(classification)) == keccak256(abi.encodePacked("National"))) return national;
        else if(keccak256(abi.encodePacked(classification)) == keccak256(abi.encodePacked("State"))) return state;
        else return district;
    }
    // Getters end...........................................


    // Function to Register a new User
    function addUser(
        string memory name, 
        uint day, 
        uint month,
        uint year,
        string memory sal_id,
        string memory public_id
    ) public returns (bool){

        transactionStatus = false;
        // Please Remove this when deployed in Production
        schemeIdSchemes["N001"] = national[0];
        schemeIdSchemes["S001"] = state[0];
        schemeIdSchemes["D001"] = district[0];
        // -----------------------------------------------


        address emp_id = msg.sender;
        // Code 

        // Check if the user is not already present, if it is than return false
        // Add user to users map and the emp_id in userIds 
        if(userPresent[emp_id] == 1){
            return false;
        }

        //Call the below emit if the transaction is succesful and before making it true.
        // emit userAdded(userIds);
        Date memory dob = Date(day, month, year);
        
        uint[] memory schemeIds;
        User memory user = User(name, dob, emp_id, sal_id, public_id, schemeIds, true);
        userIds.push(emp_id);
        users[emp_id] = user;
        userPresent[emp_id] = 1;

        transactionStatus = true;
        return true;
    }

    //Function to register Pension for the user.
    function applyPension(string memory classification, string memory scheme_id, uint day, uint month, uint year) public{

        transactionStatus = false;
        address emp_id = msg.sender;

        SchemeDetails[] memory schemeDetailsList = userSchemeDetails[emp_id];

        // If the scheme was already applied return false.
        for(uint i = 0; i < schemeDetailsList.length; i++){
            if(keccak256(abi.encodePacked(schemeDetailsList[i].scheme.scheme_id)) == keccak256(abi.encodePacked(scheme_id))){
                return;
            }
        }
        
        Schemess memory scheme = schemeIdSchemes[scheme_id];

        SchemeDetails memory schemeDetails = SchemeDetails(
            classification,
            scheme,
            Date(day, month, year),
            Date(day, month, year),
            Date(day, month, year)
        );

        userSchemeDetails[emp_id].push(schemeDetails);
        transactionStatus = true;

    }


    // Function to renew the pension by the user
    function renewUser(
        string memory sal_id
    ) public returns (bool){
        
        address emp_id = msg.sender;
        transactionStatus = false;

        // Code

        // If salary_id received is same for the user than renew by updating the details and return true. 
        if(keccak256(abi.encodePacked(sal_id)) == keccak256(abi.encodePacked(users[emp_id].sal_id))){
            transactionStatus = true;
        }

        // emit(emp_id, scheme_id, scheme_name);
        return true;
    }




}