// http://adventofcode.com/2017/day/1

func solveCaptcha(_ input: String) -> Int {
    guard input != "" else { return 0 }

    let last = Int(String(input.last!))!
    let first = Int(String(input.first!))!

    var sum = first == last ? last : 0

    for i in input.indices where i != input.index(before: input.endIndex) && input[i] == input[input.index(after: i)] {
        sum += Int(String(input[i]))!
    }

    return sum
}
