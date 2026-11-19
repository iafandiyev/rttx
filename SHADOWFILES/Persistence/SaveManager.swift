import Foundation
final class SaveManager {
    private let key = "shadowfiles.evidence.v1"
    func loadEvidence() -> Set<String> { Set(UserDefaults.standard.stringArray(forKey: key) ?? []) }
    func saveEvidence(_ evidence: Set<String>) { UserDefaults.standard.set(Array(evidence), forKey: key) }
}
