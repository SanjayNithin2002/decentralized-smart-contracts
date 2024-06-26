pragma solidity ^0.8.0;

contract DataOwnerContract {
    struct DataOwner {
        string id;
        string name;
        string email;
        string password;
        string department;
    }

    mapping(string => DataOwner) public dataOwners;
    string[] public dataOwnerIds;
    mapping(string => bool) public departmentExists;

    event DataOwnerCreated(string id, string name, string email, string department);

    function createDataOwner(string memory _id, string memory _name, string memory _email, string memory _password, string memory _department) public {
        require(bytes(dataOwners[_id].id).length == 0, "Data owner already exists");
        require(!_isEmailTaken(_email), "Email already exists");
        require(!departmentExists[_department], "Department already assigned to a data owner");

        dataOwners[_id] = DataOwner(_id, _name, _email, _password, _department);
        dataOwnerIds.push(_id);
        departmentExists[_department] = true;
        
        emit DataOwnerCreated(_id, _name, _email, _department);
    }

    function _isEmailTaken(string memory _email) internal view returns (bool) {
        for (uint i = 0; i < dataOwnerIds.length; i++) {
            if (keccak256(bytes(dataOwners[dataOwnerIds[i]].email)) == keccak256(bytes(_email))) {
                return true;
            }
        }
        return false;
    }

    function getById(string memory _id) public view returns (DataOwner memory) {
        require(bytes(dataOwners[_id].id).length != 0, "Data owner does not exist");
        return dataOwners[_id];
    }

    function getByEmail(string memory _email) public view returns (DataOwner memory) {
        for (uint i = 0; i < dataOwnerIds.length; i++) {
            if (keccak256(bytes(dataOwners[dataOwnerIds[i]].email)) == keccak256(bytes(_email))) {
                return dataOwners[dataOwnerIds[i]];
            }
        }
        revert("Data owner does not exist");
    }
}
