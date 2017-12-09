import Foundation

func reallocateMemory(_ banks: [Int]) -> Int {
    var previousConfigurations = Set<Int>()
    var banks = banks
    var distributions = 0

    repeat {
        previousConfigurations.insert(createBankHash(banks: banks))
        redistributeMemory(banks: &banks, fromBank: bankWithHighestUtilization(banks: banks))
        distributions += 1
    } while !previousConfigurations.contains(createBankHash(banks: banks))

    return distributions
}

private func bankWithHighestUtilization(banks: [Int]) -> Int {
    var highest = banks[0]
    var highestBank = 0

    for bank in 0..<banks.count where banks[bank] > highest {
        highest = banks[bank]
        highestBank = bank
    }

    return highestBank
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
        if distributeTo == banks.count {
            distributeTo = 0
        }

        banks[distributeTo] += 1
        distributeTo += 1
    }
}
