extension Array {
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }

    func shifted(amount: Int) -> [Element] {
        guard amount != 0 else { return self }

        var amount = amount

        if amount < 0 {
            amount += count
        }

        return Array(self[amount..<count] + self[0..<amount])
    }

    mutating func shift(amount: Int) {
        self = shifted(amount: amount)
    }
}

func ==(lhs: [[String]], rhs: [[String]]) -> Bool {
    guard lhs.count == rhs.count else { return false }

    for i in 0..<lhs.count where lhs[i] != rhs[i] {
        return false
    }

    return true
}

func pad(_ string: String, to: Int) -> String {
    var padded = string

    for _ in 0..<to-string.count {
        padded = "0" + padded
    }

    return padded
}
