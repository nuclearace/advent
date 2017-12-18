import Dispatch
import Foundation

// http://adventofcode.com/2017/day/18

private let lock = DispatchSemaphore(value: 1)
private var deadlock = false

@available(OSX 10.12, *)
func findFrequency(_ input: [String], partTwo: Bool = false) -> Int {
    if partTwo {
        let p1 = Program(input: input, pid: 0)
        let p2 = Program(input: input, pid: 1)

        p1.partner = p2
        p2.partner = p1

        Thread.detachNewThread {
            p1.run()
        }

        Thread.detachNewThread {
            p2.run()
        }

        while true {
            lock.wait()
            guard !deadlock else { break }
            lock.signal()
        }

        return p2.sendCount
    } else {
        return Duet(input: input).run()
    }
}

private class Duet {
    let input: [String]

    fileprivate var ip = 0
    fileprivate var regs = [String: Int]()
    fileprivate var lastSound = 0
    fileprivate var recoveredSound = 0

    init(input: [String]) {
        self.input = input
    }

    fileprivate func doMath(reg: String, arg: String, op: (Int, Int) -> Int) {
        let current = regs[reg, default: 0]

        if let literal = Int(arg) {
            regs[reg] = op(current, literal)
        } else {
            regs[reg] = op(current, regs[arg, default: 0])
        }
    }

    fileprivate func jumpGreaterThanZero(arg: String, offset: String) {
        let jmpVal: Int

        if let literal = Int(arg) {
            jmpVal = literal
        } else {
            jmpVal = regs[arg, default: 0]
        }

        guard jmpVal > 0 else {
            ip += 1
            return

        }

        if let literal = Int(offset) {
            ip += literal
        } else {
            ip += regs[arg, default: 0]
        }
    }

    fileprivate func playSound(arg: String) {
        if let literal = Int(arg) {
            lastSound = literal
        } else {
            lastSound = regs[arg, default: 0]
        }
    }

    fileprivate func recoverFrequency(arg: String) {
        let v: Int

        if let literal = Int(arg) {
            v = literal
        } else {
            v = regs[arg, default: 0]
        }

        guard v != 0 else { return }

        recoveredSound = lastSound
        ip = input.count
    }

    @discardableResult
    func run() -> Int {
        while ip < input.count {
            let line = input[ip].components(separatedBy: " ")
            guard let ins = Instruction(rawValue: line[0]) else { fatalError() }

            switch ins {
            case .snd where line.count == 2:
                playSound(arg: line[1])
                ip += 1
            case .rcv where line.count == 2:
                recoverFrequency(arg: line[1])
                ip += 1
            case .set where line.count == 3:
                setRegister(reg: line[1], arg: line[2])
                ip += 1
            case .add where line.count == 3:
                doMath(reg: line[1], arg: line[2], op: +)
                ip += 1
            case .mul where line.count == 3:
                doMath(reg: line[1], arg: line[2], op: *)
                ip += 1
            case .mod where line.count == 3:
                doMath(reg: line[1], arg: line[2], op: %)
                ip += 1
            case .jgz where line.count == 3:
                jumpGreaterThanZero(arg: line[1], offset: line[2])
            default:
                fatalError()
            }
        }

        return recoveredSound
    }

    fileprivate func setRegister(reg: String, arg: String) {
        if let literal = Int(arg) {
            regs[reg] = literal
        } else {
            regs[reg] = regs[arg, default: 0]
        }
    }
}

private class Program : Duet {
    let pid: Int
    weak var partner: Program!
    var sendCount = 0
    var waiting = false

    private var queue = [Int]()

    init(input: [String], pid: Int) {
        self.pid = pid

        super.init(input: input)

        regs["p"] = pid

    }

    fileprivate override func playSound(arg: String) {
        let val: Int

        lock.wait()

        if let literal = Int(arg) {
            val = literal
        } else {
            val = regs[arg, default: 0]
        }

        partner.queue.append(val)
        sendCount += 1
        lock.signal()
    }

    fileprivate override func recoverFrequency(arg: String) {
        repeat {
            lock.wait()
            waiting = queue.isEmpty

            if waiting && partner.waiting {
                deadlock = true
                lock.signal()

                return
            }

            lock.signal()
        } while waiting

        lock.wait()
        regs[arg] = queue.remove(at: 0)
        lock.signal()
    }
}

private enum Instruction : String {
    case add
    case jgz
    case mod
    case mul
    case rcv
    case set
    case snd
}
