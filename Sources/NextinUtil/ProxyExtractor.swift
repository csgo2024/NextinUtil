import Foundation
import Yams

enum ExtractionError: LocalizedError {
    case plistNotFound(String)
    case keyNotFound(String)
    case invalidYamlFormat
    case missingProxiesSection

    var errorDescription: String? {
        switch self {
        case .plistNotFound(let path):
            return "Error: Plist file not found at path: \(path)"
        case .keyNotFound(let key):
            return "Error: Key '\(key)' not found or format invalid in plist"
        case .invalidYamlFormat:
            return "Error: Failed to parse YAML content"
        case .missingProxiesSection:
            return "Error: Missing 'proxies' section in YAML"
        }
    }
}

@main
struct ProxyExtractor {
    static func main() {
        do {
            let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
            let plistURL = homeDirectory.appendingPathComponent(
                "Library/Group Containers/group.com.Tommy.Nextin/Library/Preferences/group.com.Tommy.Nextin.plist"
            )
            let outputURL = homeDirectory.appendingPathComponent("Desktop/proxies.yaml")

            guard FileManager.default.fileExists(atPath: plistURL.path) else {
                throw ExtractionError.plistNotFound(plistURL.path)
            }

            let data = try Data(contentsOf: plistURL)
            guard
                let plistDict = try PropertyListSerialization.propertyList(
                    from: data, options: [], format: nil) as? [String: Any],
                let yamlString = plistDict["profile_string"] as? String
            else {
                throw ExtractionError.keyNotFound("profile_string")
            }

            guard let fullYamlDict = try Yams.load(yaml: yamlString) as? [String: Any] else {
                throw ExtractionError.invalidYamlFormat
            }

            guard let proxiesArray = fullYamlDict["proxies"] as? [[String: Any]] else {
                throw ExtractionError.missingProxiesSection
            }

            let outputDict = ["proxies": proxiesArray]
            let outputYamlString = try Yams.dump(object: outputDict)

            try outputYamlString.write(to: outputURL, atomically: true, encoding: .utf8)

            print("Success: Exported to \(outputURL.path)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
