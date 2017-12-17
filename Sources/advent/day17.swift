import Foundation

// http://adventofcode.com/2017/day/17

func spinlock(stepping: Int, partTwo: Bool = false) -> Int {
    switch partTwo {
    case true:
        return trackAddedAfterZero(stepSize: stepping)
    case false:
        return findAfter2017(stepSize: stepping)
    }
}

private func trackAddedAfterZero(stepSize step: Int) -> Int {
    var valAfter0 = 0
    var pos = 0

    for i in 1...50_000_000 {
        pos = (pos + step) % i + 1

        if pos == 1 {
            valAfter0 = i
        }
    }

    return valAfter0
}

private func findAfter2017(stepSize step: Int) -> Int {
    var buf = [0]
    var pos = 0

    for i in 1...2017 {
        pos = (pos + step) % buf.count
        buf.insert(i, at: pos + 1)
        pos += 1
    }

    return buf[buf.index(of: 2017)! + 1]
}
