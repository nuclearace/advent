// http://adventofcode.com/2017/day/1

func solveCaptcha(_ input: String, partTwo: Bool = false) -> Int {
    guard input != "" else { return 0 }
    guard !partTwo else { return solveCaptchaPartTwo(input) }

    let last = Int(String(input.last!))!
    let first = Int(String(input.first!))!

    var sum = first == last ? last : 0

    for i in input.indices where i != input.index(before: input.endIndex) && input[i] == input[input.index(after: i)] {
        sum += Int(String(input[i]))!
    }

    return sum
}

func solveCaptchaPartTwo(_ input: String) -> Int {
    let stepDistance = input.count / 2
    var sum = 0

    for i in 0..<input.count {
        let curIndex = input.index(input.startIndex, offsetBy: i)
        let curNum = input[curIndex]
        let distanceToEnd = input.distance(from: curIndex, to: input.endIndex)
        let nextIndex: String.Index

        if stepDistance >= distanceToEnd {
            nextIndex = input.index(input.startIndex, offsetBy: stepDistance - distanceToEnd)
        } else {
            nextIndex = input.index(curIndex, offsetBy: stepDistance)
        }

        if curNum == input[nextIndex] {
             sum += Int(String(curNum))!
        }
    }

    return sum
}
