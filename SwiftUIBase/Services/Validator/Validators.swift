import Foundation

// MARK: Validation Rule
protocol ValidationRule {
    func validate(_ value: String) throws
}

// MARK: Validation Error
struct ValidationError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

// MARK:  Required
struct Required: ValidationRule {
    let message: String
    
    func validate(_ value: String) throws {
        if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw ValidationError(message: message)
        }
    }
}

// MARK: Length
struct Length: ValidationRule {
    let min: Int
    let max: Int
    let message: String
    
    func validate(_ value: String) throws {
        if value.count < min || value.count > max {
            throw ValidationError(message: message)
        }
    }
}

// MARK: Regex
struct Regex: ValidationRule {
    let pattern: String
    let message: String
    
    func validate(_ value: String) throws {
        if value.range(of: pattern, options: .regularExpression) == nil {
            throw ValidationError(message: message)
        }
    }
}

// MARK: Email Rule
struct Email: ValidationRule {
    let message: String
    
    func validate(_ value: String) throws {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        try Regex(pattern: pattern, message: message).validate(value)
    }
}

// MARK: Stong Password
struct StrongPassword: ValidationRule {
    let message: String
    
    func validate(_ value: String) throws {
        let pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z\\d]).{8,}$"
        try Regex(pattern: pattern, message: message).validate(value)
    }
}

// MARK: Compare Rule
struct EqualTo: ValidationRule {
    let other: String
    let message: String
    
    func validate(_ value: String) throws {
        if value != other {
            throw ValidationError(message: message)
        }
    }
}

// MARK: Website
struct Website: ValidationRule {
    let message: String
    
    func validate(_ value: String) throws {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
              detector.firstMatch(in: value, range: NSRange(location: 0, length: value.count)) != nil
        else {
            throw ValidationError(message: message)
        }
    }
}

// MARK: Digits Only
struct DigitsOnly: ValidationRule {
    let message: String
    
    func validate(_ value: String) throws {
        if value.range(of: "^[0-9]+$", options: .regularExpression) == nil {
            throw ValidationError(message: message)
        }
    }
}


// MARK: Validator:
struct Validator {
    static func validate(_ value: String, rules: [ValidationRule]) throws {
        for rule in rules {
            try rule.validate(value)
        }
    }
}
