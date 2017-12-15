//
// Created by Erik Little on 12/14/17.
//

import Foundation

func findSeverity(_ input: [[Int]], partTwo: Bool = false) -> Int {
    var firewall = [Int: Int]()
    var severity = 0
    var delayCount = 0

    for row in input {
        firewall[row[0]] = row[1]
    }

    for (pos, height) in firewall where scan(height: height, time: pos) == 0 {
        severity += pos * height
    }

    waiting: for wait in 0..<Int.max {
        for (pos, height) in firewall where scan(height: height, time: wait + pos) == 0 {
            continue waiting
        }

        delayCount = wait
        break
    }

    return partTwo ? delayCount : severity
}

private func scan(height: Int, time: Int) -> Int {
    let offset = time % ((height - 1) << 1)

    return offset > height - 1 ? (height - 1) << 1 - offset : offset
}
