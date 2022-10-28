// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.17;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol";

error BenBKNFT__NotEnoughFunds();
error BenBKNFT__MaxSupplyExceeded();
error BenBKNFT__MaxNftsPerWalletExceeded();

contract BenBKNFT is Initializable, ERC721Upgradeable, ERC721EnumerableUpgradeable, UUPSUpgradeable, OwnableUpgradeable, ERC721URIStorageUpgradeable {

    using StringsUpgradeable for uint256;
    uint256 private constant MAX_SUPPLY = 40;
    uint256 private constant PRICE = 0.1 ether;
    uint256 private constant MAX_NFTS_PER_ADDRESS = 3;
    uint256 tokenId;
    string baseURI;

    mapping(address => uint) NftsPerAddress;

    function initialize(string memory _baseURI) initializer public {
        __ERC721_init("BenBKNFT", "BBK");
        __ERC721Enumerable_init();
        __ERC721URIStorage_init();
        __Ownable_init();
        baseURI = _baseURI;
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {

    }

    function mint() external payable {
        if(msg.value < PRICE) {
            revert BenBKNFT__NotEnoughFunds();
        }
        if(totalSupply() >= MAX_SUPPLY) {
            revert BenBKNFT__MaxSupplyExceeded();
        }
        if(NftsPerAddress[msg.sender] + 1 > MAX_NFTS_PER_ADDRESS) {
            revert BenBKNFT__MaxNftsPerWalletExceeded();
        }
        NftsPerAddress[msg.sender] += 1;
        tokenId += 1;
        _mint(msg.sender, tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
        returns (string memory)
    {
        require(
        _exists(tokenId),
        "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
            ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ".json"))
            : "";
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
    {
        super._burn(tokenId);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }  

}