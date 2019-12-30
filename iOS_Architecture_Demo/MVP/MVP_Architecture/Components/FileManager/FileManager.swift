//
//  FileManager.swift
//  CoreComponents
//
//  Created by Yogesh Makwana on 22/07/19.
//  Copyright © 2019 Volansys Technologies. All rights reserved.
//

import Foundation

// MARK: - FileManager
extension FileManager {
    
    static var shared: FileManager {
        return FileManager.default
    }
    
    /**
     we can create directory in cache directory by this method
     foldername :- passed any folder name string so directory of that name created
     */
    private func createCacheDirectoryWithPath(_ foldername: String) -> String {
        let paths = getDirectoryPath(forDirectory: .cachesDirectory).appendingPathComponent(foldername)
        let cPath = paths.path
        if !FileManager.shared.fileExists(atPath: cPath) {
            do {
                try FileManager.shared.createDirectory(atPath: cPath, withIntermediateDirectories: true, attributes: nil)
            } catch let err {
                print(err.localizedDescription)
            }
        }
        return cPath
    }
    
    /**
     we can create directory in document directory by this method
     foldername :- passed any folder name string so directory of that name created
     */
    private func createDocumentDirectoryWithPath(_ foldername: String) -> String {
        let documentDirectory = getDirectoryPath(forDirectory: .documentDirectory).appendingPathComponent(foldername)
        let dPath = documentDirectory.path
        
        if !FileManager.shared.fileExists(atPath: dPath) {
            do {
                try FileManager.shared.createDirectory(atPath: dPath, withIntermediateDirectories: true, attributes: nil)
            } catch let err {
                print(err.localizedDescription)
            }
        }
        return dPath
    }
    
    /**
     File exist or not on given URL that we can fetch
     
     urlFile :- its optional , you have to pass path Url of specific file else it will fetch URL of todays log file automatically
     */
    func isFileExist(urlFile : URL? = nil) -> Bool {
        
        let pathComponent = urlFile ?? getFilePathbyDate()
        
        guard pathComponent != nil else{
            return false
        }
        
        return FileManager.shared.fileExists(atPath:  pathComponent!.path)
    }
    
    /**
     Directory exist or not of log files that provides
     
     urlFile :- its optional , you have to pass path Url of specific directory
     */
    func isDirectroryExist(urlDirectory : URL) -> Bool {
        var isDir: ObjCBool = false
        if FileManager.shared.fileExists(atPath: urlDirectory.path, isDirectory: &isDir) {
            return isDir.boolValue
        }
        return false
    }
    
    /**
     If logfiles directory is not exist then it will create directory
     
     directoryName :- pass directory name so that directory would created
     */
    func createDirectory(directoryName : String) -> String {
        return FileManager.shared.createDocumentDirectoryWithPath(directoryName)
    }
    
    /**
     It will provide array of all file's URLS of log directory
     
     urlDirectory :- pass specific directory's url so that directory's all files url array you will got
     */
    func getAllFilesOfDirectory(urlDirectory : URL) -> [URL]? {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: urlDirectory, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
            
            
            // process files
            return fileURLs
        } catch {
            print("Error while enumerating files \(urlDirectory.path): \(error.localizedDescription)")
            return nil
        }
    }
    
    /**
     It will remove file from provided URL
     
     url :- URL of specific file which you want to remove
     */
    func removeFileWithURL(url : URL) -> String {
        do {
            try FileManager.shared.removeItem(at: url)
            return url.path
        } catch {
            return error.localizedDescription
        }
    }
}
