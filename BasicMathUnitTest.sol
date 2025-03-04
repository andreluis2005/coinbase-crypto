// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

import "./Cafe.sol";
import "./Assert.sol";

using List for List.ARList;

interface IBasicContractTest {
    function adder(
        uint _a,
        uint _b
    ) external returns (uint result, bool success);

    function subtractor(
        uint _a,
        uint _b
    ) external returns (uint result, bool success);
}

library Caller {
    function callRemoteAdder(
        IBasicContractTest _submission,
        uint _a,
        uint _b
    ) internal returns (uint, bool, bool) {
        try _submission.adder(_a, _b) returns (uint result, bool success) {
            return (result, success, false);
        } catch {
            return (0, false, true);
        }
    }

    function callRemoteSubtractor(
        IBasicContractTest _submission,
        uint _a,
        uint _b
    ) internal returns (uint, bool, bool) {
        try _submission.subtractor(_a, _b) returns (uint result, bool success) {
            return (result, success, false);
        } catch {
            return (0, false, true);
        }
    }
}

contract test1Plus2 is ITest, Assert {
    function execute(
        address _submissionAddress
    ) external override returns (Cafe.TestResult memory) {
        IBasicContractTest submission = IBasicContractTest(_submissionAddress);
        Cafe.TestResult memory testResult;
        testResult.assertResults.create();
        testResult.message = "1 + 2 should equal 3 and NOT return an error";
        (uint res, bool err, bool callError) = Caller.callRemoteAdder(
            submission,
            1,
            2
        );
        if (callError) {
            testResult.assertResults.push(
                Assert.AssertResult(false, "Call to adder failed", "", "", "")
            );
        } else {
            testResult.assertResults.push(Assert.equal(res, 3));
            testResult.assertResults.push(Assert.isFalse(err));
        }
        return testResult;
    }
}

contract test1PlusMaxInt is ITest, Assert {
    function execute(
        address _submissionAddress
    ) external override returns (Cafe.TestResult memory) {
        IBasicContractTest submission = IBasicContractTest(_submissionAddress);
        Cafe.TestResult memory testResult;
        testResult.assertResults.create();
        testResult.message = "1 + MAX_INT should equal 0 and return an error";
        (uint res, bool err, bool callError) = Caller.callRemoteAdder(
            submission,
            1,
            type(uint).max
        );
        if (callError) {
            testResult.assertResults.push(
                Assert.AssertResult(false, "Call to adder failed", "", "", "")
            );
        } else {
            testResult.assertResults.push(Assert.equal(res, 0));
            testResult.assertResults.push(Assert.isTrue(err));
        }
        return testResult;
    }
}

contract test2Minus1 is ITest, Assert {
    function execute(
        address _submissionAddress
    ) external override returns (Cafe.TestResult memory) {
        IBasicContractTest submission = IBasicContractTest(_submissionAddress);
        Cafe.TestResult memory testResult;
        testResult.assertResults.create();
        testResult.message = "2 - 1 should equal 1 and NOT return an error";
        (uint res, bool err, bool callError) = Caller.callRemoteSubtractor(
            submission,
            2,
            1
        );
        if (callError) {
            testResult.assertResults.push(
                Assert.AssertResult(
                    false,
                    "Call to subtractor failed",
                    "",
                    "",
                    ""
                )
            );
        } else {
            testResult.assertResults.push(Assert.equal(res, 1));
            testResult.assertResults.push(Assert.isFalse(err));
        }
        return testResult;
    }
}

contract test1Minus2 is ITest, Assert {
    function execute(
        address _submissionAddress
    ) external override returns (Cafe.TestResult memory) {
        IBasicContractTest submission = IBasicContractTest(_submissionAddress);
        Cafe.TestResult memory testResult;
        testResult.assertResults.create();
        testResult.message = "1 - 2 should equal 0 and return an error";
        (uint res, bool err, bool callError) = Caller.callRemoteSubtractor(
            submission,
            1,
            2
        );
        if (callError) {
            testResult.assertResults.push(
                Assert.AssertResult(
                    false,
                    "Call to subtractor failed",
                    "",
                    "",
                    ""
                )
            );
        } else {
            testResult.assertResults.push(Assert.equal(res, 0));
            testResult.assertResults.push(Assert.isTrue(err));
        }
        return testResult;
    }
}

// NOTE: It might be better to centralize the token distributor
contract BasicMathUnitTest is Cafe {
    constructor() ERC721("Basic Contracts Pin", "SCDBC") {
        tests.push(new test1Plus2());
        tests.push(new test1PlusMaxInt());
        tests.push(new test2Minus1());
        tests.push(new test1Minus2());
    }
}
