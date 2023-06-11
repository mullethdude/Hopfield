// SPDX-License-Identifier: AGPL-1.0
pragma solidity ^0.8.13;

import "./ERC721Base.sol";
import "base64-sol/base64.sol";
import 'solidity-proxy/src/Proxied.sol';

contract Neuro721 is ERC721Base, Proxied { 
    uint256 _lastId;
    string internal _prefix;

    mapping(uint256 => int256[]) neuralState;    
  
    mapping (uint256 => mapping (uint256  => int256)) w;
    /// @dev constructors
	/// @param initialPrefix the prefix that will be prepended to every user message goig forward
	constructor(string memory initialPrefix) {
		// the proxied modifier from `hardhat-deploy` (see `postUpgrade` function)
		//  ensure postUpgrade effect can only be used once when the contract is deployed without proxy.
		//  by calling that function in the constructor
		//  we ensure the contract behave the same whether it is deployed through a proxy or not.
		//  when the contract is deployed without proxy, the postUpgrade can never be called
		postUpgrade(initialPrefix);
	}

	//
	/// @dev called by the admin when the contract is deployed as a proxy
	/// @param initialPrefix the prefix that will be prepended to every user message goig forward
	function postUpgrade(string memory initialPrefix) public proxied {
		_prefix = initialPrefix;
	}

    function trainer(uint256 numbneuro, uint256 astatembly,uint256 pat2) external {
        //parse base on numbneuro
        int256[25]  memory tempo; 
        int256[25]  memory tempo2; 
        for (uint256 i = 0; i < numbneuro; i++) {
            uint256 tpo=(astatembly >> i) & 1;
            int256 pm=-1;
            if(tpo==1){
                pm=1;
            }
            tempo[i]=pm;
            tpo=(pat2 >> i) & 1;
            if(tpo==1){
               tempo2[i]=1;
            }
            else{
                tempo2[i]=-1;
            }

        }
        int256 wijk=10;
        int256 loc=0;
        for (uint256 k = 0; k <2; k++) {
        for (uint256 i = 0; i < numbneuro; i++) {
            loc=0;
            for (uint256 j = i+1; j < numbneuro; j++) {
                if(i==j){continue;}
                w[i][j]=((tempo[i]*tempo[j])+(tempo2[i]*tempo2[j]))/2;
                w[j][i]=w[i][j];         
            }      
            for (uint256 j = 0; j < numbneuro; j++) {
                if(i==j){continue;}
                loc+=(w[i][j]*neuralState[i+1][0]);
            }
            if(loc<0){
                neuralState[i+1][0]=-1*neuralState[i+1][0];
            }
        }
        }  
    }

    function test(uint256 numbneuro, uint256 astatembly) external {

        int256[25]  memory tempo; 

         int256 loc=0;
        for (uint256 i = 0; i < numbneuro; i++) {
            uint256 tpo=(astatembly >> i) & 1;
            int256 pm=-1;
            if(tpo==1){
                pm=1;
            }
            tempo[i]=pm;
        }
        for (uint256 k = 0; k <1; k++) {
        for (uint256 i = 0; i < numbneuro; i++) {
            loc=0;
            for (uint256 j = 0; j < numbneuro; j++) {
                if(i==j){continue;}
                loc+=(w[i][j]*tempo[i]);
            }
            if(loc<0){
                tempo[i]=-1*tempo[i];
            }
        }
        }
        for (uint256 i = 0; i < numbneuro; i++) {
            neuralState[i+1][0]=tempo[i];
        }

    }

    function initneural(uint256 numbneuro, uint256 astatembly) external {

        int256[25]  memory tempo; 


        for (uint256 i = 0; i < numbneuro; i++) {
            uint256 tpo=(astatembly >> i) & 1;
            int256 pm=-1;
            if(tpo==1){
                pm=1;
            }
            tempo[i]=pm;
   
            
            neuralState[i+1][0]=pm; 
        }

    }

    function uint2str(uint256 num) private pure returns (string memory _uintAsString) {
        unchecked {
            if (num == 0) {
                return "0";
            }

            uint256 j = num;
            uint256 len;
            while (j != 0) {
                len++;
                j /= 10;
            }

            bytes memory bstr = new bytes(len);
            uint256 k = len - 1;
            while (num != 0) {
                bstr[k--] = bytes1(uint8(48 + (num % 10)));
                num /= 10;
            }

            return string(bstr);
        }
    }

    
    function tokenURI(uint256 tokenId) external view returns (string memory) {
        string memory tokenIdStr = uint2str(tokenId);
        // uint256 abs;
        // int256 sign;
        // string memory signstr ="";
        // bytes memory negate=new bytes(1);    
        // negate[0]= bytes1(uint8(45));
        // if(neuralState[tokenId][0]<0){
        //     sign=-1;
        //     abs=uint256(neuralState[tokenId][0]*sign);
        //     signstr=string(negate);
        // }
        // else{
        //     abs=uint256(neuralState[tokenId][0]);
        // }
        //string memory nSTR= string.concat(signstr,uint2str(abs) );
        bytes memory negate=new bytes(1);    
        negate[0]= bytes1(uint8(45));
        string memory nSTR="";
        if(neuralState[tokenId][0]<0){
            nSTR= string(negate);
        }
 
        return
            string(
                abi.encodePacked(
                    // solhint-disable quotes
                    'data:text/plain,{"name":"Token ',
                    tokenIdStr,
                    '","description":"',
                    tokenIdStr,
                    '","state":',nSTR,'1}'
                )        
            );
    }

    function symbol() external pure returns (string memory) {
        return "Hfn";
    }

    function name() external pure returns (string memory) {
        return "Hopfield";
    }

    /// @notice Check if the contract supports an interface.
    /// 0x01ffc9a7 is ERC-165.
    /// 0x80ac58cd is ERC-721
    /// 0x5b5e139f is ERC-721 Metadata (tokenURI, symbol, name)
    /// @param id The id of the interface.
    /// @return Whether the interface is supported.
    function supportsInterface(bytes4 id) public pure virtual override returns (bool) {
        return id == 0x01ffc9a7 || id == 0x80ac58cd || id == 0x5b5e139f;
    }

    function mint(uint256 num) external {
        uint256 id = _lastId;
        for (uint256 i = 0; i < num; i++) {
            id++;
            _mint(msg.sender, id);
        }
        int256 l=-1;
        if(block.timestamp%2==0){
            l=1;
        }
        neuralState[id].push(l); 
        _lastId = id;
    }
}
