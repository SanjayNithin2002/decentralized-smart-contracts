pragma solidity ^0.8.0;

contract FileContract {
    struct File {
        string id;
        string title;
        string department;
        string role;
        string filepath;
        string mimetype;
        string uploadedAt;
        string merkleRoot;
        string originalName;
        string size;
    }

    mapping(string => File) public files;
    string[] public fileIds;

    event FileCreated(string id, string title, string department, string role, string filepath, string mimetype, string uploadedAt, string merkleRoot, string originalName, string size);
    event FileDeleted(string id);

    function createFile(string memory _id, string memory _title, string memory _department, string memory _role, string memory _filepath, string memory _mimetype, string memory _uploadedAt, string memory _merkleRoot, string memory _originalName, string memory _size) public {
        files[_id] = File(_id, _title, _department, _role, _filepath, _mimetype, _uploadedAt, _merkleRoot, _originalName, _size);
        fileIds.push(_id);
        emit FileCreated(_id, _title, _department, _role, _filepath, _mimetype, _uploadedAt, _merkleRoot, _originalName, _size);
    }

    function deleteFile(string memory _id) public {
        require(bytes(files[_id].id).length != 0, "File does not exist");
        delete files[_id];
        emit FileDeleted(_id);
    }

    function getFileById(string memory _id) public view returns (File memory) {
        require(bytes(files[_id].id).length != 0, "File does not exist");
        return files[_id];
    }

    function getFilesByDepartment(string memory _department) public view returns (File[] memory) {
        uint count = 0;
        for (uint i = 0; i < fileIds.length; i++) {
            if (keccak256(abi.encodePacked(files[fileIds[i]].department)) == keccak256(abi.encodePacked(_department))) {
                count++;
            }
        }
        
        File[] memory result = new File[](count);
        uint index = 0;
        for (uint i = 0; i < fileIds.length; i++) {
            if (keccak256(abi.encodePacked(files[fileIds[i]].department)) == keccak256(abi.encodePacked(_department))) {
                result[index] = files[fileIds[i]];
                index++;
            }
        }
        
        return result;
    }
}
