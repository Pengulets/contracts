// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.3;

import "../utils/StringConcat.sol";

contract StringConcatMock {
    using StringConcat for string;

    function strConcat5(string memory _a, string memory _b, string memory _c, string memory _d, string memory _e) public pure returns (string memory) {
        return StringConcat.strConcat(_a, _b, _c, _d, _e);
    }

    function strConcat4(string memory _a, string memory _b, string memory _c, string memory _d) public pure returns (string memory) {
        return StringConcat.strConcat(_a, _b, _c, _d);
    }

    function strConcat3(string memory _a, string memory _b, string memory _c) public pure returns (string memory) {
        return StringConcat.strConcat(_a, _b, _c);
    }

    function strConcat2(string memory _a, string memory _b) public pure returns (string memory) {
        return StringConcat.strConcat(_a, _b);
    }
}
