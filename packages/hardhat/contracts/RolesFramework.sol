pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./RolesFrameworkBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract RolesFramework is RolesFrameworkBase, Ownable {
    event RoleCreated(uint256 id, string name);
    event RuleAdded(uint256 id, uint256 rule, address token, uint256 quantity);
    event RuleUpdated(
        uint256 id,
        uint256 rule,
        address token,
        uint256 quantity
    );

    constructor(address _owner) Ownable() {
        // what should we do on deploy?
        if (_owner != address(0)) {
            transferOwnership(_owner);
        }
    }

    /**
     * @dev Create a new role
     * @param _name Name of the role
     */
    function createRole(string memory _name)
        external
        onlyOwner
        returns (uint256 id)
    {
        id = rolesCount;
        rolesCount++;

        roles[id].name = _name;

        emit RoleCreated(id, _name);
    }

    /**
     * @dev Add a rule to a role
     * @param _role Role id
     * @param _token Token address
     * @param _quantity Quantity of tokens
     */
    function addRule(
        uint256 _role,
        address _token,
        uint256 _quantity
    ) external onlyOwner returns (uint256 id) {
        require(roles[_role].rulesCount < 255, "Role has too many rules");

        // will revert if the token doesn't have a balanceOf
        ERCWithBalance(_token).balanceOf(msg.sender);

        id = roles[_role].rulesCount;
        roles[_role].rulesCount++;

        roles[_role].rules[id].token = _token;
        roles[_role].rules[id].quantity = _quantity;

        emit RuleAdded(id, _role, _token, _quantity);
    }

    /**
     * @dev Deactivate a rule
     * @param _role Role id
     * @param _rule Rule id
     */
    function deactivateRule(uint256 _role, uint256 _rule)
        external
        onlyOwner
        returns (bool updated)
    {
        updateRule(_role, _rule, 0);
        return true;
    }

    /**
     * @dev Update a rule
     * @param _role Role id
     * @param _rule Rule id
     * @param _quantity Quantity of tokens
     */
    function updateRule(
        uint256 _role,
        uint256 _rule,
        uint256 _quantity
    ) public onlyOwner returns (bool updated) {
        roles[_role].rules[_rule].quantity = _quantity;

        emit RuleUpdated(
            _rule,
            _role,
            roles[_role].rules[_rule].token,
            _quantity
        );

        return true;
    }
}

contract RolesFrameworkImmutable is RolesFrameworkBase {
    constructor() {
        // set up owner role
        roles[0].name = "owner";
        roles[0].rulesCount = 1;
        roles[0].rules[0] = Rule(address(0x12452142facbe), 1 * 10**18);

        roles[1].name = "active";
        roles[1].rulesCount = 2;
        roles[1].rules[0] = Rule(address(0), 1 * 10**18);
        roles[1].rules[1] = Rule(address(0x15452142facbe), 1 * 10**18);

        // set equal to number of roles set above
        rolesCount = 2;
    }
}
