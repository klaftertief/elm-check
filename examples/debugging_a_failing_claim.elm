import Check exposing (Claim, Evidence, suite, claim, that, is, for, true, quickCheck)
import Check.Investigator exposing (tuple, float, dropIf)
import Check.Test

import ElmTest

testWithZero : Claim
testWithZero =
  claim
    "Multiplication and division are inverse operations"
  `that`
    (\(x, y) -> x * y / y)
  `is`
    (\(x, y) -> x)
  `for`
    tuple (float, float)

testWithoutZero : Claim
testWithoutZero =
  claim
    "Multiplication and division are inverse operations, if zero if omitted"
  `that`
    (\(x, y) -> x * y / y)
  `is`
    (\(x, y) -> x)
  `for`
    dropIf (\(x, y) -> y == 0) (tuple (float, float))

testForNearness : Claim
testForNearness =
  claim
    "Multiplication and division are near inverse operations, if zero if omitted"
  `true`
    (\(x, y) -> abs ((x * y / y) - x) < 1e-10)
  `for`
    dropIf (\(x, y) -> y == 0) (tuple (float, float))

myClaims : Claim
myClaims =
  suite "Claims about multiplication and division"
    [testWithZero, testWithoutZero, testForNearness]

evidence : Evidence
evidence = quickCheck myClaims

main = ElmTest.elementRunner (Check.Test.evidenceToTest evidence)