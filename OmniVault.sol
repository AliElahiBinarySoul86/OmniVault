// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

error ZeroAddress();
error InvalidGrant();
error NotStarted();
error NothingToClaim();

contract OmniVault is ERC20, AccessControl, ReentrancyGuard {
    bytes32 public constant TREASURY_ROLE = keccak256("TREASURY_ROLE");

    struct Stream {
        uint128 total;
        uint128 claimed;
        uint64 start;
        uint64 end;
    }

    mapping(address => Stream[]) public streams;

    constructor(address admin) ERC20("OmniVault Token", "OMNI") {
        if (admin == address(0)) revert ZeroAddress();
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        _grantRole(TREASURY_ROLE, admin);
    }

    /* ───────────── Treasury Mint ───────────── */

    function mintToVault(uint256 amount)
        external
        onlyRole(TREASURY_ROLE)
    {
        _mint(address(this), amount);
    }

    /* ───────────── Streaming / Vesting ───────────── */

    function createStream(
        address beneficiary,
        uint128 amount,
        uint64 start,
        uint64 end
    ) external onlyRole(TREASURY_ROLE) {
        if (
            beneficiary == address(0) ||
            amount == 0 ||
            end <= start
        ) revert InvalidGrant();

        streams[beneficiary].push(
            Stream({
                total: amount,
                claimed: 0,
                start: start,
                end: end
            })
        );
    }

    function claim(uint256 index) external nonReentrant {
        Stream storage s = streams[msg.sender][index];
        if (block.timestamp < s.start) revert NotStarted();

        uint256 vested = _vestedAmount(s);
        uint256 claimable = vested - s.claimed;
        if (claimable == 0) revert NothingToClaim();

        s.claimed += uint128(claimable);
        _transfer(address(this), msg.sender, claimable);
    }

    function _vestedAmount(Stream memory s)
        internal
        view
        returns (uint256)
    {
        if (block.timestamp >= s.end) return s.total;

        return
            (s.total * (block.timestamp - s.start)) /
            (s.end - s.start);
    }
}