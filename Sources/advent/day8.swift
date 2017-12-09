import Foundation
import Regex

private let regex = try! Regex(string: "([a-z]{1,3}) (inc|dec) (-?\\d{1,500}) if ([a-z]{1,3}) (>|<|==|!=|<=|>=) (-?\\d{1,500})")

// http://adventofcode.com/2017/day/8

func largestRegisterValue(afterExecuting instructions: [String]) -> Int {
    var registers = [String: Int]()

    for instruction in instructions {
        guard let match = regex.firstMatch(in: instruction),
              let reg = match.captures[0],
              let ins = Instruction(rawValue: match.captures[1] ?? ""),
              let value = Int(match.captures[2] ?? ""),
              let condReg = match.captures[3],
              let cond = Comparison(rawValue: match.captures[4] ?? ""),
              let condValue = Int(match.captures[5] ?? "") else { fatalError() }

        guard cond.apply(lhs: registers[condReg] ?? 0, rhs: condValue) else { continue }

        registers[reg] = ins.apply(lhs: registers[reg] ?? 0, rhs: value)
    }

    return registers.values.max()!
}

private enum Comparison : String {
    case greaterThan = ">"
    case lessThan = "<"
    case equals = "=="
    case greaterThanOrEquals = ">="
    case lessThanOrEquals = "<="
    case notEquals = "!="

    func apply<T: Comparable>(lhs: T, rhs: T) -> Bool {
        switch self {
        case .greaterThan:
            return lhs > rhs
        case .lessThan:
            return lhs < rhs
        case .equals:
            return lhs == rhs
        case .greaterThanOrEquals:
            return lhs >= rhs
        case .lessThanOrEquals:
            return lhs <= rhs
        case .notEquals:
            return lhs != rhs
        }
    }
}

private enum Instruction : String {
    case increment = "inc"
    case decrement = "dec"

    func apply<T: Numeric>(lhs: T, rhs: T) -> T {
        switch self {
        case .increment:
            return lhs + rhs
        case .decrement:
            return lhs - rhs
        }
    }
}


