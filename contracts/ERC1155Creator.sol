// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// @author: ntnu.CCLAB

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

error No_TokenUriSet();

contract ERC1155Creator is ERC1155, ReentrancyGuard, Ownable {
    string public constant name = "IX";

    mapping(uint256 => string) private s_uris;
    mapping(uint256 => uint256) private s_totalSupply;

    constructor() ERC1155("") {}

    /**
     * @dev Mint token
     */
    function mint(
        address to,
        uint256 tokenId,
        uint256 amount
    ) public onlyOwner nonReentrant {
        // 檢查是否已經設定好Token URI
        if (bytes(s_uris[tokenId]).length == 0) {
            revert No_TokenUriSet();
        }
        // 鑄造
        _mint(to, tokenId, amount, "");
    }

    /**
     * @dev MintBatch token
     */
    function mintBatch(
        address to,
        uint256[] memory tokenId,
        uint256[] memory amount
    ) public onlyOwner nonReentrant {
        // 檢查是否已經設定好Token URI
        for (uint256 i = 0; i < tokenId.length; i++) {
            if (bytes(s_uris[tokenId[i]]).length == 0) {
                revert No_TokenUriSet();
            }
        }
        // 鑄造
        _mintBatch(to, tokenId, amount, "");
    }

    /**
     * @dev Set token URI
     */
    function setTokenURI(uint256 tokenId, string calldata uri_) public {
        s_uris[tokenId] = uri_;
    }

    /**
     * @dev Get token URI
     */
    function uri(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        return s_uris[tokenId];
    }

    /**
     * @dev Total amount of tokens in with a given id.
     */
    function totalSupply(uint256 tokenId)
        external
        view
        virtual
        returns (uint256)
    {
        return s_totalSupply[tokenId];
    }

    /**
     * @dev See {ERC1155-_mint}.
     */
    function _mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) internal virtual override {
        super._mint(account, id, amount, data);
        s_totalSupply[id] += amount;
    }

    /**
     * @dev See {ERC1155-_mintBatch}.
     */
    function _mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal virtual override {
        super._mintBatch(to, ids, amounts, data);
        for (uint256 i = 0; i < ids.length; i++) {
            s_totalSupply[ids[i]] += amounts[i];
        }
    }

    /**
     * @dev See {ERC1155-_burn}.
     */
    function _burn(
        address account,
        uint256 id,
        uint256 amount
    ) internal virtual override {
        super._burn(account, id, amount);
        s_totalSupply[id] -= amount;
    }

    /**
     * @dev See {ERC1155-_burnBatch}.
     */
    function _burnBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts
    ) internal virtual override {
        super._burnBatch(account, ids, amounts);
        for (uint256 i = 0; i < ids.length; i++) {
            s_totalSupply[ids[i]] -= amounts[i];
        }
    }
}
