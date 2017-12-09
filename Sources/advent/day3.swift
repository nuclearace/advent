import Foundation

func getDistance(from num: Int) -> Int {
    let nearestRoot = Int(pow(Double(num), 0.5))
    let shellSize = nearestRoot % 2 == 0 ? nearestRoot + 1 : nearestRoot + 2
    let lastSquare = Int(pow(Double(shellSize - 2), 2))
    let difference = num - lastSquare
    let shellMinusOne = shellSize - 1
    let cornersAndSquares = (0..<5).map({ lastSquare + $0 * shellMinusOne })
    let halfShellSize = shellSize / 2

    if num == lastSquare {
        return shellSize - 2
    } else if difference % (shellSize - 1) == 0 {
        return shellSize - 1
    } else {
        return (1..<5).map({i in
            guard num < cornersAndSquares[i] else { return nil }

            return {corner in
                let a = ((shellSize - 2) / 2) - (num - corner - 1)

                return halfShellSize + abs(a)
            }(cornersAndSquares[i - 1])
        }).flatMap({ $0 })[0]
    }
}
