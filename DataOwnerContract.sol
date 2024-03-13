pragma solidity ^0.8.0;

contract DataOwnerContract {
    struct DataOwner {
        string id;
        string name;
        string email;
        string password;
        string department;
        string role;
    }

    mapping(string => DataOwner) public dataOwners;
    string[] public dataOwnerIds;
    mapping(string => bool) public emailExists;

    event DataOwnerCreated(string id, string name, string email, string department, string role);

    function createDataOwner(string memory _id, string memory _name, string memory _email, string memory _password, string memory _department, string memory _role) public {
        require(!emailExists[_email], "Email already exists");
        dataOwners[_id] = DataOwner(_id, _name, _email, _password, _department, _role);
        dataOwnerIds.push(_id);
        emailExists[_email] = true;
        emit DataOwnerCreated(_id, _name, _email, _department, _role);
    }

    function doesEmailExist(string memory _email) public view returns (bool) {
        return emailExists[_email];
    }

    function getDataOwnerById(string memory _id) public view returns (DataOwner memory) {
        require(bytes(dataOwners[_id].id).length != 0, "Data owner does not exist");
        return dataOwners[_id];
    }

    function getAllDataOwners() public view returns (DataOwner[] memory) {
        DataOwner[] memory result = new DataOwner[](dataOwnerIds.length);
        for (uint i = 0; i < dataOwnerIds.length; i++) {
            result[i] = dataOwners[dataOwnerIds[i]];
        }
        return result;
    }
}