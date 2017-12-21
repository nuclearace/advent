import Foundation

// http://adventofcode.com/2017/day/21

func fractalImage(_ input: [String], partTwo: Bool = false) -> Int {
    var image = [
        [false, true, false],
        [false, false, true],
        [true, true, true]
    ]

    var enhancements = [Enhancement]()

    for enhancement in input {
        let splitEnhancement = enhancement.components(separatedBy: " => ")
        let input = splitEnhancement[0].components(separatedBy: "/").map({ $0.map({ $0 == "#" }) })
        let output = splitEnhancement[1].components(separatedBy: "/").map({ $0.map({ $0 == "#" }) })
        let numInput = input.count

        func newCord(r: Int, c: Int, flipped: Bool, reverseR: Bool, reverseC: Bool) -> Bool {
            var matchR = r
            var matchC = c

            if reverseR {
                matchR = numInput - 1 - r
            }

            if reverseC {
                matchC = numInput - 1 - c
            }

            if flipped {
                (matchC, matchR) = (matchR, matchC)
            }

            return input[matchR][matchC]
        }

        for flipped in [true, false] {
            for reverseR in [true, false] {
                for reverseC in [true, false] {
                    enhancements.append(Enhancement(input: (0..<numInput).map({r in
                        return (0..<numInput).map({c in
                            return newCord(r: r, c: c, flipped: flipped, reverseR: reverseR, reverseC: reverseC)
                        })
                    }), output: output))
                }
            }
        }
    }

    for _ in 0..<(partTwo ? 18 : 5) {
        let numRows = image.count
        let blockSize = numRows % 2 == 0 ? 2 : 3
        let innerBlockSize = numRows / blockSize
        let newSize = numRows / blockSize * (blockSize + 1)
        let newImage = (0..<innerBlockSize).map({i -> [[[Bool]]] in
            return (0..<innerBlockSize).map({x -> [[Bool]] in
                return enhancements.first(where: {enhancement in
                    return enhancement == (0..<blockSize).map({(rr: Int) -> [Bool] in
                        return (0..<blockSize).map({(cc: Int) -> Bool in
                            return image[i*blockSize+rr][x*blockSize+cc]
                        })
                    })
                })!.output
            })
        })

        image = (0..<newSize).map({r in
            return (0..<newSize).map({c in
                let (r0, r1) = (r / ( blockSize + 1), r % (blockSize + 1))
                let (c0, c1) = (c / ( blockSize + 1), c % (blockSize + 1))

                return newImage[r0][c0][r1][c1]
            })
        })
    }

    return image.flatMap({ $0.map({ $0 ? 1 : 0 }) }).reduce(0, +)
}

private struct Enhancement {
    let input: [[Bool]]
    let output: [[Bool]]

    static func ==(lhs: Enhancement, rhs: [[Bool]]) -> Bool {
        return lhs.input == rhs
    }
}
