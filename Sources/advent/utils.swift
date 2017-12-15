func pad(_ string: String, to: Int) -> String {
    var padded = string

    for _ in 0..<to-string.count {
        padded = "0" + padded
    }

    return padded
}
