import Foundation

// http://adventofcode.com/2017/day/20

func simulateParticles(_ input: [String], partTwo: Bool = false) -> Int {
    var particles = [Particle]()

    for particleDef in input {
        particles.append(Particle(particleDef: particleDef))
    }

    var closestParticleNum = 0

    for _ in 0..<500 {
        var particlesByLocation = [String: Int]()
        var markForDeath = [Int]()

        for i in 0..<particles.count {
            particles[i].tick()

            if particles[i].originDistance < particles[closestParticleNum].originDistance {
                closestParticleNum = i
            }
        }

        if partTwo {
            for i in 0..<particles.count where !particles[i].dead {
                let particle = particles[i]

                if let firstParticleI = particlesByLocation[particle.pointString] {
                    markForDeath += [i, firstParticleI]
                } else {
                    particlesByLocation[particle.pointString] = i
                }
            }

            for deathIndex in markForDeath {
                particles[deathIndex].dead = true
            }
        }
    }

    return partTwo ? particles.filter({ !$0.dead }).count : closestParticleNum
}

private struct Particle {
    typealias Vector = (x: Int, y: Int, z: Int)

    var x: Int
    var y: Int
    var z: Int

    var acceleration: Vector
    var velocity: Vector

    var dead = false

    var originDistance: Int {
        return [abs(x), abs(y), abs(z)].reduce(0, +)
    }

    var pointString: String {
        return "\(x),\(y),\(z)"
    }

    init(particleDef: String) {
        let particleInfo = particleDef.components(separatedBy: ", ")
        let initialStateInfo = particleInfo[0].dropFirst(3).dropLast().components(separatedBy: ",")
        let velocityInfo = particleInfo[1].dropFirst(3).dropLast().components(separatedBy: ",")
        let accelInfo = particleInfo[2].dropFirst(3).dropLast().components(separatedBy: ",")

        (x, y, z) = (Int(initialStateInfo[0])!, Int(initialStateInfo[1])!, Int(initialStateInfo[2])!)
        velocity = (Int(velocityInfo[0])!, Int(velocityInfo[1])!, Int(velocityInfo[2])!)
        acceleration = (Int(accelInfo[0])!, Int(accelInfo[1])!, Int(accelInfo[2])!)
    }

    mutating func tick() {
        (velocity.x, velocity.y, velocity.z) = (velocity.x + acceleration.x,
                                                velocity.y + acceleration.y,
                                                velocity.z + acceleration.z)
        (x, y, z) = (x + velocity.x, y + velocity.y, z + velocity.z)
    }
}

