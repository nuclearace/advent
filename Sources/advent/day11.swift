import Foundation

func getHexDistance(_ input: String, partTwo: Bool = false) -> Int {
    var (x, y, z) = (0, 0, 0)
    var dists = [Int]()

    for direction in input.components(separatedBy: ",") {
        switch direction {
        case "n":
            y += 1
            z -= 1
        case "ne":
            x += 1
            z -= 1
        case "nw":
            x -= 1
            y += 1
        case "s":
            y -= 1
            z += 1
        case "se":
            x += 1
            y -= 1
        case "sw":
            x -= 1
            z += 1
        default:
            fatalError()
        }

        dists.append((abs(x) + abs(y) + abs(z)) / 2)
    }

    if partTwo {
        print("The maximum distance he ever got was \(dists.max()!)")
    }

    return (abs(x) + abs(y) + abs(z)) / 2
}
