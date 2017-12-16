import Foundation

// http://adventofcode.com/2017/day/15

func generatorBattle(seeds: (Int, Int), partTwo: Bool = false) -> Int {
    let genA = Generator(seed: seeds.0, factor: 16807, bias: partTwo ? 4 : 1)
    let genB = Generator(seed: seeds.1, factor: 48271, bias: partTwo ? 8 : 1)

    var n = 0

    for _ in 0..<(partTwo ? 5_000_000 : 40_000_000) {
        let a = genA.next()
        let b = genB.next()

        guard a & Int(UInt16.max) == b & Int(UInt16.max) else { continue }

        n += 1
    }

    return n
}

private class Generator {
    let bias: Int
    let factor: Int
    var seed: Int

    init(seed: Int, factor: Int, bias: Int) {
        self.seed = seed
        self.factor = factor
        self.bias = bias
    }

    func next() -> Int {
        seed = (seed * factor) % 2147483647

        guard seed % bias == 0 else { return next() }

        return seed
    }
}
