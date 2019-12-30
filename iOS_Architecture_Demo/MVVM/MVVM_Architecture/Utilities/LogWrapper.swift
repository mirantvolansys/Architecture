//
//  LogWrapper.swift
//  Component_Mirant
//
//  Created by Mirant Patel on 16/07/19.
//  Copyright © 2019 Mirant Patel. All rights reserved.
//

import Foundation
import UIKit
import QuickLook

struct LogKeys {
    static let filePrefix = "logDebugger_File_"
    static let logDirectoryName = "logDirectory"
    static let logFileEextension = "txt"
    static let logCommonDateFormat = "MM-dd-yyyy"
    static let logUnnecessoryFile = ".DS_Store"
}

//Log type enum which you have to pass for log type
enum LogType: String {
    case click = "Click"
    case navigation = "Navigation"
    case api = "API"
    case info = "Info"
    case error = "Error"
    case debug = "Debug"
    case verbose = "Verbose"
    case warning = "Warning"
    case critical = "Critical"
    case message = "Message"
    case tryCatch = "TryCatch"
    case trace = "Trace"
}

/**
 Will give filename as per specific date
 
 date:- date object for which date's filename you want
 */
private func getFileNameByDate(date: Date? = Date()) -> String {
    let myString = "\(LogKeys.filePrefix)\(date!.string(withFormat: LogKeys.logCommonDateFormat))"
    return myString
}

/**
 Will give URL/path of file as per specific date
 
 date:- date object for which date's file path you want
 */
func getFilePathbyDate(date: Date? = Date()) -> URL? {
    let directoryName = LogKeys.logDirectoryName
    let documentDirURL = getDirectoryPath(forDirectory: .documentDirectory)
    
    let fileURL = documentDirURL.appendingPathComponent(directoryName).appendingPathComponent(getFileNameByDate(date: date)).appendingPathExtension(LogKeys.logFileEextension)
    
    return fileURL
}

/**
 Will give URL/path of file as per log directory name
 */
func getDirectoryPathWithFolderName() -> URL {
    let directoryName = LogKeys.logDirectoryName
    let documentDirURL = getDirectoryPath(forDirectory: .documentDirectory)
    
    return documentDirURL.appendingPathComponent(directoryName)
}

/**
 Create/Append file. If same date file is not ready then file created and if already available then append the log into it.
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 type :- type of log like api, click etc
 */
private func createAppendFileForToday(username: String? = nil, logMessage: String, type: LogType) {
    
    if !FileManager.shared.isFileExist() {
        let directoryName = LogKeys.logDirectoryName
        let documentDirURL = getDirectoryPath(forDirectory: .documentDirectory)
        
        let fileURL = documentDirURL.appendingPathComponent(directoryName)
        
        if !FileManager.shared.isDirectroryExist(urlDirectory: fileURL) {
            print(FileManager.shared.createDirectory(directoryName: LogKeys.logDirectoryName))
        }
        
        deleteOlderLogFilesCreatedBefore(days: -15)
        
        // Save data to file
        let writeString = "================ Start logging ================\n"
        do {
            // Write to the file
            try writeString.write(to: getFilePathbyDate()!, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed writing to URL: \(getFilePathbyDate()!), Error: " + error.localizedDescription)
        }
    }
    
    //All data
    var dataString: String
    if username != nil {
        dataString = "\n\(type.rawValue) : Username:\(username ?? ""): \(logMessage)\n"
    } else {
        dataString = "\n\(type.rawValue): \(logMessage)\n"
    }
    
    do {
        let fileHandle = try FileHandle(forWritingTo: getFilePathbyDate()!)
        fileHandle.seekToEndOfFile()
        fileHandle.write(dataString.data(using: .utf8)!)
        fileHandle.closeFile()
    } catch {
        print("Error writing to file \(error)")
    }
}

/**
 It will remove old files which is older than specific days
 
 days:- It's optional, If you want to remove log files which are older than specific days. That number pass in it else it will remove files older than 15 days from current date.
 */
private func deleteOlderLogFilesCreatedBefore(days: Int = -15) {
    let fileURLs = FileManager.shared.getAllFilesOfDirectory(urlDirectory: getDirectoryPathWithFolderName())
    
    guard fileURLs != nil else {
        return
    }
    
    for url: URL in fileURLs! {
        var stringPath = url.lastPathComponent
        stringPath = stringPath.removeSubString(removeString: "\(LogKeys.filePrefix)")
        stringPath = stringPath.removeSubString(removeString: ".\(LogKeys.logFileEextension)")
        print(stringPath)
        
        if stringPath == LogKeys.logUnnecessoryFile {
            continue
        }
        
        let date1 = stringPath.toDate(withFormat: LogKeys.logCommonDateFormat)!
        let date2 = Date().dateBeforeAfterDays(days: days)
        
        if date1 < date2 {
            print(FileManager.shared.removeFileWithURL(url: url))
        }
    }
    
}

/**
 Print log and save log as click type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printClick(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .click)
}

/**
 Print log and save log as Navigation type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printNavigation(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .navigation)
}

/**
 Print log and save log as API type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printAPI(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .api)
}

/**
 Print log and save log as Info type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printInfo(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .info)
}

/**
 Print log and save log as Error type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printError(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .error)
}

/**
 Print log and save log as Debug type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printDebug(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .debug)
}

/**
 Print log and save log as Verbose type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printVerbose(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .verbose)
}

/**
 Print log and save log as Warning type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printWarning(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .warning)
}

/**
 Print log and save log as Critical type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printCritical(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .critical)
}

/**
 Print log and save log as Message type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printMessage(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .message)
}

/**
 Print log and save log as TryCatch type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printTryCatch(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .tryCatch)
}

/**
 Print log and save log as Trace type
 
 username :- It's optional, If we want to store username into log pass it.
 data :- Message/Log details which we want to store
 */
func printTrace(username: String? = nil, logMessage: String) {
    createAppendFileForToday(username: username, logMessage: logMessage, type: .trace)
}

extension UIViewController: QLPreviewControllerDataSource {
    
    //This url of file which you want to open in QLPreview
    private static var urlManageForQuickLook: URL?
    
    // MARK: - Datasource methods of QLPreviewController
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return UIViewController.urlManageForQuickLook! as QLPreviewItem
    }
    
    /**
     Show preview of any log file by proper date
     
     dateFile :- date object need to pass for proper file
     */
    func showPreview(_ dateFile: Date?) {
        
        guard dateFile != nil && (getFilePathbyDate(date: dateFile!) != nil) else {
            self.showAlertView(withTitle: "Please give perfect date", message: "No Data found")
            return
        }
        
        UIViewController.urlManageForQuickLook = getFilePathbyDate(date: dateFile!)
        
        let quickLookController = QLPreviewController()
        quickLookController.dataSource = self
        self.present(quickLookController, animated: true, completion: nil)
    }
    
    /**
     Show preview of any file by proper url
     
     urlFile :- pass url to see any file in QLPreview
     */
    func showPreviewByPath(_ urlFile: URL) {
        
        UIViewController.urlManageForQuickLook = urlFile
        
        let quickLookController = QLPreviewController()
        quickLookController.dataSource = self
        self.present(quickLookController, animated: true, completion: nil)
    }
    
    /**
     Show Alert view and once pass proper date in to textfield it will give log file in QLPreview
     */
    func showLogFile() {
        let alertController = UIAlertController(title: "Enter date", message: "enter date in MM-dd-yyyy", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter Date in MM-dd-yyyy"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { _ -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.showPreview((firstTextField.text?.toDate(withFormat: "MM-dd-yyyy")))
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ -> Void in
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: UIApplication extensions

extension UIApplication {
    
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
