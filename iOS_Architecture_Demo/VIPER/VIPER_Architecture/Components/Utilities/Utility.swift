//
//  Utility.swift
//  BasicUtilities
//
//  Created by Shrenik on 15/07/19.
//  Copyright © 2019 Volansys. All rights reserved.
//

import Foundation
import UIKit

let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

struct PasswordOption: OptionSet {
    let rawValue: Int
    
    static let capitalAlphabet = PasswordOption(rawValue: 1 << 0)
    static let specialCharacter = PasswordOption(rawValue: 1 << 1)
    static let numericValue = PasswordOption(rawValue: 1 << 2)
    static let smallAlphabet = PasswordOption(rawValue: 1 << 3)
    static let noRestriction = PasswordOption(rawValue: 1 << 4)
    
    var selectedOptions: String {
        var option = String()
        if contains(.specialCharacter) {
            option += "Special Character, "
        }
        if contains(.capitalAlphabet) {
            option += "Capital, "
        }
        if contains(.smallAlphabet) {
            option += "Small Alphabet, "
        }
        if contains(.numericValue) {
            option += "Numeric values, "
        }
        if contains(.noRestriction) {
            option += "No Restriction"
        }
        
        return option
    }
}

/// Get Directory Path
///
/// - Parameter directory: directory i.e. documentDirectory, Cachedirectory, applicationDirectory, etc.
/// - Returns: Path to the directory
//func getDirectoryPath(forDirectory directory:FileManager.SearchPathDirectory) -> String {
//    let paths = NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true)
//    return paths[0]
//}

/// Get Directory Path URL
///
/// - Parameter directory: Directory Name
/// - Returns: URL of Directory's path
func getDirectoryPath(forDirectory directory: FileManager.SearchPathDirectory) -> URL {
    do {
        return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    } catch {
        fatalError("Error getting directory path")
    }
}

// START : Check for Device Type
enum UIUserInterfaceIdiom: Int {
    case unspecified
    case phone
    case pad
}

/// Retruns screen dimension
struct ScreenSize {
    static let screenWidth          = UIScreen.main.bounds.size.width
    static let screenHeight         = UIScreen.main.bounds.size.height
    static let screenMaxLength      = max(ScreenSize.screenWidth, ScreenSize.screenHeight)
    static let screenMinLength      = min(ScreenSize.screenWidth, ScreenSize.screenHeight)
}

/// Checks for the device type
struct DeviceType {
    static let isIphone             = UIDevice.current.userInterfaceIdiom == .phone
    static let isIphone4OrLess      = isIphone && UIScreen.main.nativeBounds.size.height < 1136.0
    static let isIphone5            = isIphone && UIScreen.main.nativeBounds.size.height == 1136.0
    static let isIphone5C           = isIphone5
    static let isIphone5S           = isIphone5
    static let isIphone6            = isIphone && UIScreen.main.nativeBounds.size.height == 1334.0
    static let isIphone6S           = isIphone6
    static let isIphone6P           = isIphone && UIScreen.main.nativeBounds.size.height == 2208.0
    static let isIphone6SPlus       = isIphone6P
    static let isIphone7            = isIphone6
    static let isIphone7P           = isIphone6P
    static let isIphone8            = isIphone6
    static let isIphone8P           = isIphone6P
    static let isIphoneX            = isIphone && UIScreen.main.nativeBounds.height == 2436.0
    static let isIphoneXR           = isIphone && UIScreen.main.nativeBounds.height == 1792.0
    static let isIphoneXS           = isIphoneX
    static let isIphoneXSMax        = isIphone && UIScreen.main.nativeBounds.height == 2688.0
    static let isIpad               = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screenMaxLength == 1024.0
    static let isIpadPro9         = isIpad
    static let isIpadPro12        = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.screenMaxLength == 1366.0
    static let isTV                 = UIDevice.current.userInterfaceIdiom == .tv
    static let isCarPlay            = UIDevice.current.userInterfaceIdiom == .carPlay
}

// MARK: - Primitive datatype's string value
extension LosslessStringConvertible {
    var string: String { return .init(self) }
}

// MARK: - String Extension
extension String {
    
    /// Validates emailAddress
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return range(of: emailRegEx, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// Validates Phone number. i.e. +919999999999, 9999999999 both are valid
    var isValidPhoneNumber: Bool {
        // 9999999999, +919999999999 both are valid phone numbers. Max 14 digit length
        let phoneNumRegex = "^(?:(\\+)|(00))?[0-9]{6,14}$"
        return range(of: phoneNumRegex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    #if canImport(Foundation)
    var date: Date? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: selfLowercased)
    }
    
    /**
     Convert string object to date
     
     format :- Which format of string you provide that you have to pass. Like MM-dd-yyyy or dd-MM-yyyy etc
     */
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    /**
     Remove any sub string from string
     
     removeString :- String which you want to remove from your main string
     */
    func removeSubString(removeString: String) -> String {
        return self.replacingOccurrences(of: removeString, with: "")
    }
    #endif
    
    /// This function auto generates Password Regex according to selected options and validates the password accordingly
    ///
    /// - Parameters:
    ///   - options: User selected array of options which contains parameters like smallAlphabet, NumericValue, etc.
    ///   - minLength: minimum password length
    ///   - maxLength: maximum password length
    /// - Returns: true/false result
    func isPasswordValid(forSelectedOptions options: PasswordOption, minLength: Int, maxLength: Int) -> Bool {
        if options.contains(.noRestriction) {
            return true
        }
        
        let smallAlphaRegex = "(?=.*[a-z])"
        let capitalAlphaRegex = "(?=.*[A-Z])"
        let numberRegex = "(?=.*\\d)"
        let specialCharRegex = "(?=.*[_#@$!%*?&])"
        
        // Regex pattern should be something like this. "(?=.*[a-z])[a-z]{1,6}$".
        var passwordRegexPattern = ""
        var passwordOptions = "["   // Regex option should be appended again post '()'
        
        if options.contains(.capitalAlphabet) {
            passwordRegexPattern.append(capitalAlphaRegex)
            passwordOptions.append("A-Z")
        }
        if options.contains(.numericValue) {
            passwordRegexPattern.append(numberRegex)
            passwordOptions.append("\\d")
        }
        if options.contains(.smallAlphabet) {
            passwordRegexPattern.append(smallAlphaRegex)
            passwordOptions.append("a-z")
        }
        if options.contains(.specialCharacter) {
            passwordRegexPattern.append(specialCharRegex)
            passwordOptions.append("_#@$!%*?&")
        }
        
        passwordRegexPattern.append(passwordOptions + "]")  // Closing the bracket at the end of Regex
        passwordRegexPattern.append("{\(minLength),\(maxLength)}$")
        #if DEBUG
        print("Password Regex Pattern : ", passwordRegexPattern)
        #endif
        
        return range(of: passwordRegexPattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// String Length
    var length: Int {
        return self.count
    }
    
    /// Entered string is blank (i.e. only white space)
    ///
    /// - Returns: true/false result
    func isWhiteSpace() -> Bool {
        if self == " " {
            return true
        }
        return false
    }
    
    /// Removes white spaces and new line characters from Begining and End of string
    var trimmed: String {
        // Remove white spaces and trim the string
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// User can find that the text is only alphabetic or not
    var isAlphabetic: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
    
    /// Check whether String is Blank or not
    var isBlank: Bool {
        // Remove white space and then check the string is empty or not
        return trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
    
    /// Hex String to UIColor
    var uiColor: UIColor {
        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /// Get Integervalue from String
    ///
    /// - Returns: Integer value
    func integerValue() -> Int? {
        guard let intVal = Int(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) else {
            return nil
        }
        return intVal
    }
    
    /// Get Double Value from String
    ///
    /// - Returns: Double value
    func doubleValue() -> Double? {
        guard let doubleVal = Double(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) else {
            return nil
        }
        return doubleVal
    }
    
    /// Get Float Value from String
    ///
    /// - Returns: float value
    func floatValue() -> Float? {
        guard let floatVal = Float(self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)) else {
            return nil
        }
        return floatVal
    }
    
    /// Check whether it contains a substring
    ///
    /// - Parameter find: substring
    /// - Returns: true/false
    func contains(find: String) -> Bool {
        return self.range(of: find) != nil
    }
    
    /// Check whether parent string contains substring (ignoring casing)
    ///
    /// - Parameter find: Substring
    /// - Returns: true/false
    func containsIgnoringCase(find: String) -> Bool {
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

extension NSMutableAttributedString {
    func bold(_ text: String, font: UIFont) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let boldString = NSMutableAttributedString(string: text, attributes: attrs)
        append(boldString)
        
        return self
    }
}

// MARK: - DateFormatter
extension Formatter {
    static let date = DateFormatter()
}

// MARK: - Date Extension
extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                              in timeZone: TimeZone = .current,
                              locale: Locale = .current) -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        return Formatter.date.string(from: self)
    }
    
    var localizedDescription: String { return localizedDescription() }
    
    var fullDate: String { return localizedDescription(dateStyle: .full, timeStyle: .none)  }
    var shortDate: String { return localizedDescription(dateStyle: .short, timeStyle: .none)  }
    var fullTime: String { return localizedDescription(dateStyle: .none, timeStyle: .full)  }
    var shortTime: String { return localizedDescription(dateStyle: .none, timeStyle: .short)   }
    var fullDateTime: String { return localizedDescription(dateStyle: .full, timeStyle: .full)  }
    var shortDateTime: String { return localizedDescription(dateStyle: .short, timeStyle: .short)  }
    
    /// Date to String
    ///
    /// - Parameter format: format of date
    /// - Returns: String value of date
    func string(withFormat format: String = "dd/MM/YYYY") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    /// ISO8601 String
    var iso8601String: String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        return dateFormatter.string(from: self)
    }
    
    struct Gregorian {
        static let calendar = Calendar(identifier: .gregorian)
    }
    
    /// Get StartDate of week for the date
    var startOfWeek: Date {
        return Gregorian.calendar.date(from: Gregorian.calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
    
    /// Get EndDate of week for the date
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: .day, value: 6, to: self.startOfWeek)!
    }
    
    /// Get StartDate of Month for the date
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    /// Get EndDate of Month for the date
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    /// Get No. of days for the month
    func getDaysInMonth() -> Int {
        let calendar = Calendar.current
        
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        return numDays
    }
    
    /// Get Previous month for the date
    func previousMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
    
    /// Get Next month for the date
    func nextMonth() -> Date {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)!
    }
    
    /// Get Previous day from the date
    func previousDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
    
    /// Get Next day from the date
    func nextDay() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    
    func dayNumberOfWeek() -> Int {
        return Calendar.current.dateComponents([.weekday], from: self).weekday!
    }
    
    func dayNumberOfMonth() -> Int {
        return Int(self.string(withFormat: "dd"))!
    }
    
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    /**
     Get date of past/future by passign days
     
     days :- if you pass positive number then it will give future date and if minus then past date according to number of days
     */
    func dateBeforeAfterDays(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    /// Get Current year from the date
    var currentYear: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// Convert Date to specific timezone
    ///
    /// - Parameters:
    ///   - initTimeZone: current TimeZone
    ///   - timeZone: New timeZone
    /// - Returns: Converted date
    func convertToTimeZone(from initTimeZone: TimeZone, to timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
    
    // START: Compare Current Date with another date
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    // END: Compare Current Date with another date
}

// MARK: - UIView
extension UIView {
    
    // Making the View Rounded (Circular view)
    func rounded() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.size.width * 0.5
        self.clipsToBounds = true
    }
    
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        } set {
            self.layer.borderWidth = newValue
        }
    }
    
    var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        } set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        } set {
            self.layer.cornerRadius = newValue
        }
    }
}

// MARK: - Color Extension
extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    /// UIColor to RGB
    ///
    /// - Parameters:
    ///   - red: Red Color
    ///   - green: Green Color
    ///   - blue: Blue Color
    ///   - alpha: Alpha
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: min(1.0, alpha))
    }
    
    /// UIColor to HexString
    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let rgb: Int = (Int)(red*255)<<16 | (Int)(green*255)<<8 | (Int)(blue*255)<<0
        
        return String(format: "#%06x", rgb)
    }
}

// MARK: - Image extension
extension UIImage {
    enum ImageQuality: CGFloat {
        case lowest     = 0
        case low        = 0.25
        case medium     = 0.5
        case high       = 0.75
        case highest    = 1
    }
    
    func resized(withCompressionQuality quality: ImageQuality) -> Data? {
        return jpegData(compressionQuality: quality.rawValue)
    }
    
    /// SwifterSwift: Size in bytes of UIImage
    var bytesSize: Int {
        return jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// SwifterSwift: Size in kilo bytes of UIImage
    var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// Compressed Image
    ///
    /// - Parameter percentage: %
    /// - Returns: Compressed UIImage Object
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image { _ in
            draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    /// Resize image to specific width
    ///
    /// - Parameter width: width
    /// - Returns: resized Image
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image { _ in
            draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    /// Crop imag to specific frame
    ///
    /// - Parameters:
    ///   - width: width
    ///   - height: height
    /// - Returns: cropped image
    func crop(withWidth width: Double = 300, andHeight height: Double = 300) -> UIImage? {
        
        if let cgImage = self.cgImage {
            
            let contextImage: UIImage = UIImage(cgImage: cgImage)
            
            let contextSize: CGSize = contextImage.size
            
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)
            
            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }
            
            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
            
            // Create bitmap image from context using the rect
            var croppedContextImage: CGImage?
            if let contextImage = contextImage.cgImage {
                if let croppedImage = contextImage.cropping(to: rect) {
                    croppedContextImage = croppedImage
                }
            }
            
            // Create a new image based on the imageRef and rotate back to the original orientation
            if let croppedImage: CGImage = croppedContextImage {
                let image: UIImage = UIImage(cgImage: croppedImage, scale: self.scale, orientation: self.imageOrientation)
                return image
            }
            
        }
        
        return nil
    }
}

// MARK: - ImageView
extension UIImageView {
    /// Download and set image to imageview
    ///
    /// - Parameters:
    ///   - url: Image URL
    ///   - contentMode: content mode
    ///   - placeHolderImage: placeHolder Image
    ///   - completionHandler: CompletionHandler which will return downloaded image
    func download(imageFromURL url: URL, contentMode: UIView.ContentMode = .scaleAspectFit, placeHolderImage: UIImage? = nil, completionHandler: (((UIImage)?) -> Void)? = nil) {
        
        image = placeHolderImage
        self.contentMode = contentMode
        URLSession.shared.dataTask(with: url) { (data, response, _) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data,
                let image = UIImage(data: data)
                else {
                    completionHandler?(nil)
                    return
            }
            DispatchQueue.main.async { [unowned self] in
                self.image = image
                completionHandler?(image)
            }
            }.resume()
    }
}

// MARK: - Textfield
extension UITextField {
    
    /// Textfield Type to identify the purpose of textfield
    ///
    /// - emailAddres: Textfield for Email-Address
    /// - password: Textfield for Password
    /// - normal: Textfield for general purpose
    enum TextfieldType {
        case emailAddress
        case phoneNumber
        case password
        case normal
    }
    
    /// Set textType and accordingly keyboardtype, placeholder , etc. will get updated
    var textType: TextfieldType {
        get {
            if keyboardType == .emailAddress {
                return .emailAddress
            } else if isSecureTextEntry {
                return .password
            } else if keyboardType == .phonePad {
                return .phoneNumber
            }
            return .normal
        } set {
            switch newValue {
            case .emailAddress :
                keyboardType = .emailAddress
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = false
                placeholder = "Email Address"
                
            case .password:
                keyboardType = .asciiCapable
                autocorrectionType = .no
                autocapitalizationType = .none
                isSecureTextEntry = true
                placeholder = "Password"
                
            case .phoneNumber:
                keyboardType = .phonePad
                autocorrectionType = .no
                isSecureTextEntry = false
                placeholder = "Mobile Number"
                
            case .normal:
                isSecureTextEntry = false
                autocorrectionType = .no
                autocapitalizationType = .none
                keyboardType = .default
                placeholder = ""
            }
        }
    }
    
    /// Check if text field is empty.
    var isEmpty: Bool {
        return self.text?.trimmed.isEmpty == true
    }
    
    /// Return trimmed text i.e. No space or new lines in beginning and end
    var trimmedText: String? {
        return text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Clear input text
    func clear() {
        self.text = ""
        self.attributedText = NSAttributedString(string: "")
    }
    
    /// Set placeholder text color
    ///
    /// - Parameter color: placeholder Text color
    func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.withAlphaComponent(0.6).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.setBottomBorder()
    }
}

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.5
        }
    }
}

extension UIViewController {
    /// Display Error Alert
    ///
    /// - Parameters:
    ///   - message: Error Message to display
    ///   - actions: Button actions
    ///   - dismissOnOutisideTouch: Should get dismiss if user touches outside the alert-box ?
    func showErrorAlert(withMessage message: String?, withActions actions: [UIAlertAction] = [], dismissOnOutisideTouch: Bool = false) {
//        showAlertView(withTitle: "Error", message: message, withActions: actions, dismissOnOutisideTouch: dismissOnOutisideTouch)
        showAlertView(withTitle: "Error", message: message, withActions: actions, dismissOnOutisideTouch:dismissOnOutisideTouch)
    }
    
    /// Show an Alertview on top of view controller
    ///
    /// - Parameters:
    ///   - title: Alert box title
    ///   - message: Alert message
    ///   - actions: Button actions (Default button will be OK)
    ///   - dismissOnOutisideTouch: Should get dismiss if user touches outside the alert-box ?
    
    //func showAlertView(withTitle title: String?, message: String?, withActions actions: [UIAlertAction] = [], dismissOnOutisideTouch: Bool = false, completionHandler:(((Int?) -> Void)?))
    
    func showAlertView(withTitle title: String?, message: String?, withActions actions: [UIAlertAction] = [], dismissOnOutisideTouch: Bool = false) {

        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.isEmpty {
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertViewController.addAction(defaultAction)
        }
        
        for action in actions {
            alertViewController.addAction(action)
        }
        
        // set property for ipad
        alertViewController.popoverPresentationController?.sourceView = self.view
        alertViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        alertViewController.popoverPresentationController?.sourceRect = self.view.bounds
        
        // show alert view controller
        self.present(alertViewController, animated: true) {
            
            if dismissOnOutisideTouch {
                // Feedback Point F6 : I don't like the Text "Stornieren". To leave this box without an action, you should just have to click on the screen
                alertViewController.view.superview?.subviews[1].isUserInteractionEnabled = true
                alertViewController.view.superview?.subviews[1].addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            }
        }
    }
    
    // Dismissing Alert when tapping outside Alert-box
    @objc func alertControllerBackgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
