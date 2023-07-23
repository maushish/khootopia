// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
contract ChatApp{
    //User struct
    struct user{
        string name;
        friend [] friendlist;
    }
    struct friend{
        address pubkey;
        string name;

    }
    struct message{
        address senderl;
        uint256 timestamp;
        string msg;
    }
    //fetch all users into the smart contract
    struct AlluserStruck{
        string name:
        address accountAddress;

    }
    AlluserStruck[] getAllusers;
    mapping (address=>user) userList;//list of all users
    mapping (bytes32=>message[]) allMessages;//All messages will be in this array
    //Check User Exists
    function checkUserExists(address pubkey)public  view returns(bool){
        return bytes(userList[pubkey].name).length>0;

    }

    //Create Account
    function createAccount (string calldata name) external {
        require(checkUserExists(msg.sender)==false,"User already exists");
        require(bytes(name).length>0,"Usermae cannot be empty");
        userList[msg.sender].name=name;
        getAllusers.push(AlluserStruck(name, msg.sender));
    }
    //Get Username
    //using string memory coz we want to view the name of the registered user
    function getUsername(address pubkey) external view returns(string memory){
        require(checkUserExists(pubkey),"User is not registered");
        return userList[pubkey].name;
    }

    //Add friends
    function addFriend (address friend_key , string calldata name)external {
        require(checkUserExists(msg.sender),"Create an account first");//Does your friend even exists?
        require(checkUserExists(friend_key),"User is not registered");//Is your friend registered?
        require(msg.sender!=friend_key,"Users cannot add themself as friends");//are you adding yourself as your friend?
        require(checkAlreadyFriends(msg.sender,friend_key)==false,"These users are already friends");//Is your friend already added?
        _addFriend(msg.sender,friend_key,name);
        _addFriend(friend_key,msg.sender,userList[msg.sender].name);


    }
    //Check ALready Friends
    function checkAlreadyFriends(address pubkey1, address pubkey2) internal view returns(bool){
        if (userList[pubkey1].friendlist.length > userList[pubkey2].friendlist.length){
            address tmp=pubkey1;
            pubkey1=pubkey2;
            pubkey2=tmp;

        }
        for(uint256 i=0;i<userList[pubkey1].friendlist.length; i++){
            if (userList[pubkey1].friendlist[i].pubkey==pubkey2)return true;

        }
        return false;


    }
    function _addFriend(address me, address friend_key, string memory name)internal{
        friend memory newFriend=friend(friend_key, name);
        userList[me].friendlist.push(newFriend);

    }
    //Get my friend: with this function you can get a list of all of your friends
    function getMyFriendlist()external view  returns (friend[] memory){
        return userList[msg.sender].friendlist;
    }
    //get chat code
    //this function will change the chat into a fixed 32 hash  which is not reversal so this way your chats is secured
    function _getChatCode(address pubkey1, address pubkey2)internal pure returns(bytes32){
        if (pubkey1<pubkey2){
            return keccak256(abi.encodePacked(pubkey1,pubkey2));

        }
        else return keccak256(abi.encodePacked(pubkey2,pubkey1));

            
    }
    //Send Message
    //This function contains ever
    function sendMessage(address friend_key, string calldata _msg) external{
        require(checkUserExists(msg.sender),"Create an account first");
        require(checkUserExists(friend_key),"User is not registered");
        require(checkAlreadyFriends(msg.sender, friend_key),"You are not friend with the given user");
        bytes32 chatCode =_getChatCode(msg.sender, friend_key);//calling the chat function to send the chatcode
        message memory newMsg=message(msg.sender, block.timestamp,_msg);//To type new messages
        allMessages[chatCode].push(newMsg);
    }
    //Read messages
    function readMessage(address friend_key) external view returns (message[] memory){
        bytes32 chatCode=_getChatCode(msg.sender,friend_key);
        return allMessages[chatCode];
    }

    //Fetch all registered users to our dapp
    function getAllAppUser() public view returns(AlluserStruck) memory {
        return getAllusers;
    }















}