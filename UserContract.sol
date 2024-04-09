pragma solidity ^0.8.0;

contract UserContract {
    struct User {
        string id;
        string name;
        string email;
        string password;
        string department;
        string role;
        string status;
    }

    mapping(string => User) public users;
    mapping(string => bool) public emailExists;
    string[] public userIds;

    event UserCreated(string id, string name, string email, string department, string role, string status);
    event UserApproved(string id);
    event UserDeleted(string id);
    event UserAlreadyExists(string email);

    // Error code for user already exists
    string constant ERROR_USER_EXISTS = "UE001";

    function createUser(string memory _id, string memory _name, string memory _email, string memory _password, string memory _department, string memory _role) public {
        if (emailExists[_email]) { // Check if email already exists
            emit UserAlreadyExists(_email);
            revert(ERROR_USER_EXISTS);
        }

        users[_id] = User(_id, _name, _email, _password, _department, _role, "Pending");
        userIds.push(_id);
        emailExists[_email] = true; // Mark email as existing
        emit UserCreated(_id, _name, _email, _department, _role, "Pending");
    }

    function approveUser(string memory _id) public {
        require(bytes(users[_id].id).length != 0, "User does not exist");
        User storage user = users[_id];
        user.status = "Approved";
        emit UserApproved(_id);
    }

    function deleteUser(string memory _id) public {
        require(bytes(users[_id].id).length != 0, "User does not exist");
        string memory _email = users[_id].email;
        delete users[_id];
        emailExists[_email] = false;
        emit UserDeleted(_id);
    }

    function getUser(string memory _id) public view returns (User memory) {
        require(bytes(users[_id].id).length != 0, "User does not exist");
        return users[_id];
    }

    function getUserByEmail(string memory _email) public view returns (User memory) {
        for (uint i = 0; i < userIds.length; i++) {
            if (keccak256(abi.encodePacked(users[userIds[i]].email)) == keccak256(abi.encodePacked(_email))) {
                return users[userIds[i]];
            }
        }
        revert("User does not exist");
    }

    function getUsersByDepartment(string memory _department) public view returns (User[] memory) {
        uint count = 0;
        for (uint i = 0; i < userIds.length; i++) {
            if (keccak256(abi.encodePacked(users[userIds[i]].department)) == keccak256(abi.encodePacked(_department))) {
                count++;
            }
        }

        User[] memory result = new User[](count);
        uint index = 0;
        for (uint i = 0; i < userIds.length; i++) {
            if (keccak256(abi.encodePacked(users[userIds[i]].department)) == keccak256(abi.encodePacked(_department))) {
                result[index] = users[userIds[i]];
                index++;
            }
        }

        return result;
    }

}