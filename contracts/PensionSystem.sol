// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract PensionSystem {
    bool private transaction_status;
    address private current_user;

    // ----------Structures----------
    struct Date {
        uint day;
        uint month;
        uint year;
    }

    struct Schemes {
        string scheme_id;
        string classification;
        string scheme_name;
        uint amount;
        uint eligible_age;
    }

    struct SchemeAppliedDetails {
        Schemes scheme;
        Date last_renewed;
        Date applied_date;
        Date next_renewal_date;
    }

    struct User {
        string name;
        string emp_id;
        string sal_id;
//        address public_id;
        Date dob;
        string[] applied_schemes_id;
    }
    //---------- Structures end----------

    Schemes[] district;
    Schemes[] state;
    Schemes[] national;

    constructor() public {
        national.push(Schemes("N001", "National", "National Level Pension Scheme", 50000, 60));
        state.push(Schemes("S001", "State", "State Level Pension Scheme", 49999, 60));
        district.push(Schemes("D001", "District", "District Level Pension Scheme", 49888, 60));
        district.push(Schemes("D002", "District", "District Level Pension Scheme-2", 4888, 55));

        scheme_details["N001"] = national[0];
        scheme_details["S001"] = state[0];
        scheme_details["D001"] = district[0];
        scheme_details["D002"] = district[1];
    }

    //----------Mappings----------
    mapping(address => uint) public user_present;
    mapping(address => User) user_details;
    mapping(string => Schemes) scheme_details;
    mapping(address => SchemeAppliedDetails[]) user_applied_schemes;
    // ----------Mappings end----------
//    error alreadyRegistered();
    //----------Events----------
    event userRegistered(address user_id);
    event appliedPension(string scheme_id, address user_id);
    event renewedPension(address user_id, string scheme_id);
    event userUpdated(address user);

    //----------Events end----------


    //----------Functions start----------

    // Function to register user
    function registerUser(string memory name, string memory emp_id, string memory sal_id, uint day, uint month, uint year) public {
        transaction_status = false;

        // user is already registered
        if(user_present[current_user] == 1) {
            return;
        }
        user_present[current_user] = 1;
        Date memory dob = Date(day, month, year);
        string[] memory applied_schemes_id;

        User memory new_user = User(name, emp_id, sal_id, dob, applied_schemes_id);
        user_details[current_user] = new_user;

        transaction_status = true;
        emit userRegistered(current_user);
    }

    // Function to apply pension
    function applyPension(string memory scheme_id, uint day, uint month, uint year) public {
        transaction_status = false;

        SchemeAppliedDetails[] memory applied = user_applied_schemes[current_user];

        // User has already applied in the given scheme
        for(uint i = 0; i < applied.length; ++i) {
            if(keccak256(abi.encodePacked(applied[i].scheme.scheme_id)) == keccak256(abi.encodePacked(scheme_id))){
                return;
            }
        }

        // Add current scheme id to users data
        user_details[current_user].applied_schemes_id.push(scheme_id);

        Schemes memory scheme = scheme_details[scheme_id];
        SchemeAppliedDetails memory applying = SchemeAppliedDetails(scheme, Date(day, month, year), Date(day, month, year), Date(day + 5, month, year));

        // Add current schemes details to user applied schemes data
        user_applied_schemes[current_user].push(applying);
        transaction_status = true;
        emit appliedPension(scheme_id, current_user);
    }

    // Function to renew pension for current user
    function renewPension(string memory scheme_id, uint day, uint month, uint year) public {
        transaction_status = false;

        Date memory renew_date = Date(day, month, year);
        Date memory next_renewal_date = Date(day + 5, month, year);

        // Get all the pensions in which user has applied
        SchemeAppliedDetails[] memory applied_schemes = user_applied_schemes[current_user];

        for(uint i = 0; i < applied_schemes.length; ++i) {
            // find the scheme id in the array of user applied schemes
            if(keccak256(abi.encodePacked(scheme_id)) != keccak256(abi.encodePacked(applied_schemes[i].scheme.scheme_id))) {
                // update renewed date and next_renewal_date
                applied_schemes[i].last_renewed = renew_date;
                applied_schemes[i].next_renewal_date = next_renewal_date;
                break;
            }
        }
        transaction_status = true;
        emit renewedPension(current_user, scheme_id);
    }

    // function to get transaction status
    function getTransactionStatus() public view returns(bool) {
        return transaction_status;
    }

    // function to get all the schemes in which current user has applied
    function getAllAppliedSchemes() public view returns(SchemeAppliedDetails[] memory) {
        return user_applied_schemes[current_user];
    }

    // function to get all available schemes
    function getAllSchemes(string memory classification) public view returns(Schemes[] memory) {
        if(keccak256(abi.encodePacked(classification)) == keccak256(abi.encodePacked("National"))) return national;
        else if(keccak256(abi.encodePacked(classification)) == keccak256(abi.encodePacked("State"))) return state;
        else return district;
    }

    function getUserRegistrationStatus() public view returns(bool) {
        return (user_present[current_user] == 1);
    }

    function setCurrentUser(address user) public {
        current_user = user;
        emit userUpdated(current_user);
    }

    function getUserDetails() public view returns (User memory) {
        return user_details[current_user];
    }
    //----------Functions End----------
}