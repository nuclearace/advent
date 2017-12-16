import Foundation

// http://adventofcode.com/2017/day/14

func countSquaresUsed(_ input: String, partTwo: Bool = false) -> Int {
    let numRegions: Int

    let grid = (0..<128).map({i -> [Int] in
        let hash = Array(knotHash("\(input)-\(i)"))

        return stride(from: 0, to: hash.count, by: 2).map({i -> [Int] in
            return pad(String(Int(hash[i..<min(i + 2, hash.count)].map(String.init).reduce("", +),
                                  radix: 16)!,
                              radix: 2),
                       to: 8).map({ Int(String($0))! })
        }).flatMap({ $0 })
    })

    if partTwo {
        numRegions = findNumberOfRegions(grid)
    } else {
        numRegions = 0
    }

    return partTwo ? numRegions : grid.map({row in row.reduce(0, +) }).reduce(0, +)
}

private func findNumberOfRegions(_ grid: [[Int]]) -> Int {
    var seen = [Point]()
    var n = 0

    func dfs(point p: Point) {
        guard !seen.contains(p) else { return }
        guard grid[p.x][p.y] != 0 else { return }

        seen.append(p)

        if p.x > 0 {
            dfs(point: Point(x: p.x - 1, y: p.y))
        }

        if p.y > 0 {
            dfs(point: Point(x: p.x, y: p.y - 1))
        }

        if p.x < 127 {
            dfs(point: Point(x: p.x + 1, y: p.y))
        }

        if p.y < 127 {
            dfs(point: Point(x: p.x, y: p.y + 1))
        }
    }

    for i in 0..<128 {
        for j in 0..<128 {
            let p = Point(x: i, y: j)

            guard !seen.contains(p) else { continue }
            guard grid[i][j] != 0 else { continue }

            n += 1
            dfs(point: p)
        }
    }

    return n
}

private struct Point : Equatable {
    let x: Int
    let y: Int

    static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}
