import Foundation

// http://adventofcode.com/2017/day/22

private let boardSize = 100_000

func langton(_ input: [[Bool]], partTwo: Bool = false) -> Int {
    let ant = Langton(board: input, dir: .north)

    for _ in 0..<(partTwo ? 10_000_000 : 10_000) {
        ant.step(partTwo: partTwo)
    }

    return ant.infectedCount
}

private class Langton {
    enum CellState {
        case clean, weakened, infected, flagged
    }

    enum Direction : Int {
        case north, east, west, south

        var opposite: Direction {
            switch self {
            case .north:
                return .south
            case .south:
                return .north
            case .west:
                return .east
            case .east:
                return .west
            }
        }
    }

    private let origin: Point
    private let leftTurn = [Direction.west, Direction.north, Direction.south, Direction.east]
    private let rightTurn = [Direction.east, Direction.south, Direction.north, Direction.west]
    private let xInc = [-1, 0, 0, 1]
    private let yInc = [0, 1, -1, 0]

    var infectedCount = 0

    private var board: [[CellState]]
    private var antPosition = Point(x: 0, y: 0)
    private var antDirection: Direction!
    private var stepCount = 0

    init(board: [[Bool]], dir: Direction) {
        self.board = Array(repeating: Array(repeating: CellState.clean, count: boardSize), count: boardSize)
        self.origin = Point(x: boardSize / 2, y: boardSize / 2)
        self.antDirection = dir

        buildBoard(withInput: board)
    }

    private func buildBoard(withInput input: [[Bool]]) {
        let startX = origin.x - input.count / 2
        let startY = startX
        var inputX = 0
        var inputY = 0

        for x in startX..<startX+input.count {
            for y in startY..<startY+input.count {
                board[x][y] = input[inputX][inputY] ? .infected : .clean
                inputY += 1
            }

            inputY = 0
            inputX += 1
        }
    }

    private func moveAnt() {
        antPosition.x += xInc[antDirection.rawValue]
        antPosition.y += yInc[antDirection.rawValue]
    }

    func printBoard() {
        for row in board {
            for cell in row {
                switch cell {
                case .clean:
                    print(".", terminator: "")
                case .weakened:
                    print("W", terminator: "")
                case .flagged:
                    print("F", terminator: "")
                case .infected:
                    print("#")
                }
            }

            print()
        }
    }

    func step(partTwo: Bool) {
        let ptCur = Point(x: antPosition.x + origin.x, y: antPosition.y + origin.y)
        let curState = board[ptCur.x][ptCur.y]

        switch curState {
        case .clean where partTwo:
            antDirection = leftTurn[antDirection.rawValue]
            board[ptCur.x][ptCur.y] = .weakened
        case .clean:
            infectedCount += 1
            antDirection = leftTurn[antDirection.rawValue]
            board[ptCur.x][ptCur.y] = .infected
        case .infected where partTwo:
            antDirection = rightTurn[antDirection.rawValue]
            board[ptCur.x][ptCur.y] = .flagged
        case .infected:
            antDirection = rightTurn[antDirection.rawValue]
            board[ptCur.x][ptCur.y] = .clean
        case .weakened:
            infectedCount += 1
            board[ptCur.x][ptCur.y] = .infected
        case .flagged:
            antDirection = antDirection.opposite
            board[ptCur.x][ptCur.y] = .clean
        }

        moveAnt()

        stepCount += 1
    }
}

private struct Point {
    var x: Int
    var y: Int
}
