import Foundation

// http://adventofcode.com/2017/day/5

func solveJumpMaze(_ maze: [Int], partTwo: Bool = false) -> Int {
    var maze = maze
    var ip = 0
    var steps = 0

    while ip < maze.count {
        steps += 1
        (ip, maze[ip]) = (ip + maze[ip], partTwo && maze[ip] >= 3 ? maze[ip] - 1 : maze[ip] + 1)
    }

    return steps
}
