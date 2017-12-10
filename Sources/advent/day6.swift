import Foundation

// http://adventofcode.com/2017/day/6

func reallocateMemory(_ banks: [Int], partTwo: Bool = false) -> Int {
    var previousConfigurations = Set<Int>()
    var previousConfigLocs = [Int]()
    var banks = banks
    var distributions = 0

    repeat {
        let oldHash = createBankHash(banks: banks)

        previousConfigurations.insert(oldHash)
        previousConfigLocs.append(oldHash)

        redistributeMemory(banks: &banks, fromBank: banks.index(of: banks.max()!)!)

        distributions += 1
    } while !previousConfigurations.contains(createBankHash(banks: banks))

    return partTwo ? previousConfigLocs.count - previousConfigLocs.index(of: createBankHash(banks: banks))! : distributions
}

private func createBankHash(banks: [Int]) -> Int {
    // Be sure to add the bank num to the string
    // https://i.imgur.com/nd2DnPW.png
    return (0..<banks.count).map({ String(banks[$0] + $0) }).joined().hashValue
}

private func redistributeMemory(banks: inout [Int], fromBank bank: Int) {
    let numToDistribute = banks[bank]
    var distributeTo = bank + 1

    banks[bank] = 0

    for _ in 0..<numToDistribute {
        banks[distributeTo % banks.count] += 1
        distributeTo += 1
    }
}
