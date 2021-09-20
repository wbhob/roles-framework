pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

interface ERCWithBalance {
    function balanceOf(address _owner) external view returns (uint256);
}

interface IRolesFramework {
    function listRoles(address _account)
        external
        view
        returns (uint256[] memory);

    function hasRole(uint256 _role, address _account)
        external
        view
        returns (bool);
}

contract RolesFrameworkBase is IRolesFramework {
    struct Rule {
        address token;
        uint256 quantity;
    }

    struct Role {
        string name;
        mapping(uint256 => Rule) rules;
        uint256 rulesCount;
    }

    mapping(uint256 => Role) public roles;
    uint256 public rolesCount;

    /**
     * @dev Create a new role
     * @param _account Name of the role
     */
    function listRoles(address _account)
        public
        view
        override
        returns (uint256[] memory)
    {
        uint256[] memory userRoles = new uint256[](rolesCount);
        uint256 j = 0;

        for (uint256 i = 0; i < rolesCount; i++) {
            if (hasRole(i, _account)) {
                userRoles[j] = i;
                j++;
            }
        }

        // cleanup
        uint256[] memory res = new uint256[](j);
        for (uint256 i = 0; i < j; i++) {
            res[i] = userRoles[i];
        }

        return userRoles;
    }

    /**
     * @dev Check if an account has a role
     * @param _role Role id
     * @param _account Account address
     */
    function hasRole(uint256 _role, address _account)
        public
        view
        override
        returns (bool)
    {
        for (uint256 i = 0; i < roles[_role].rulesCount; i++) {
            if (!_checkRule(_role, i, _account)) {
                return false;
            }
        }
        return true;
    }

    /**
     * @dev Check if an address matches a rule
     * @param _role Role id
     * @param _rule Rule id
     * @param _account Account address
     */
    function _checkRule(
        uint256 _role,
        uint256 _rule,
        address _account
    ) internal view returns (bool) {
        Rule memory rule = roles[_role].rules[_rule];

        if (rule.quantity == 0) {
            return true;
        }

        // also works with erc 721 tokens, or anything with a balanceOf that takes just an address
        return ERCWithBalance(rule.token).balanceOf(_account) >= rule.quantity;
    }
}
