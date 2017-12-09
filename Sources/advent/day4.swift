import Foundation

func getValidPassphraseCount(_ input: String) -> Int {
    return input.components(separatedBy: "\n")
                .map({passphrase in
                    let phrases = passphrase.components(separatedBy: " ")

                    return Set(phrases).count == phrases.count ? 1 : 0
                }).reduce(0, +)
}
