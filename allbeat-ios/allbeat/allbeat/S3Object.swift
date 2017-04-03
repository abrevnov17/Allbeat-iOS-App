//
//  S3Object.swift
//  allbeat
//
//  Created by Nathan Flurry on 6/5/16.
//  Copyright © 2016 allbeat, LLC. All rights reserved.
//

import AWSS3

enum S3DownloadError: Error {
    case unknown, cancelled, paused, completed, internalInConsistency, missingRequiredParameters, invalidParameters
    case exception(NSException)
}

extension AWSS3TransferManagerErrorType {
    func getDownloadError() -> S3DownloadError {
        switch self {
        case .unknown:
            return .unknown
        case .cancelled:
            return .cancelled
        case .paused:
            return .paused
        case .completed:
            return .completed
        case .internalInConsistency:
            return .internalInConsistency
        case .missingRequiredParameters:
            return .missingRequiredParameters
        case .invalidParameters:
            return .invalidParameters
        }
    }
}

enum S3ObjectLocation {
    case profilePicture, audio
    
    func getPath() -> String {
        switch self {
        case .profilePicture:
            return "usr-icon/"
        case .audio:
            return "music/"
        }
    }
}

class S3Object {
    static let bucket = "allbeat"
    
    // Location and key within the bucket
    var location: S3ObjectLocation
    var key: String
    
    // File key with path
    var absoluteKey: String {
        return location.getPath() + key
    }
    
    // Location of downloaded file stored locally
    var downloaded: Bool = false
    var localUrl: URL?
    var task: AWSTask<AnyObject>?
    
    init(location: S3ObjectLocation, key: String) {
        self.location = location
        self.key = key
    }
    
    // Downloads the data
    func download(_ callback: @escaping (S3Object, S3DownloadError?) -> Void) {
        guard task == nil else {
            print("Download already started.")
            return
        }
        
        // Create a transfer manager
        let transferManager = AWSS3TransferManager.default()
        
        // Get the path for where to place the downloaded file
        let downloadingFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("downloadedImage.jpg")
        let downloadingFileUrl = URL(fileURLWithPath: downloadingFilePath)
        localUrl = downloadingFileUrl
        
        // Create a request to download the file
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest?.bucket = S3Object.bucket
        downloadRequest?.key = absoluteKey
        downloadRequest?.downloadingFileURL = downloadingFileUrl
        
        // Start the download for the file
        transferManager?.download(downloadRequest).continue(
            { task -> AnyObject? in
                DispatchQueue.main.async {
                    if task.error != nil { // Error
                        self.task = nil
                        //if error.domain == AWSS3TransferManagerErrorDomain, let errorType = AWSS3TransferManagerErrorType(rawValue: error.code) {
                            //callback(self, errorType.getDownloadError())
                       // }
                    //else {
                            callback(self, .unknown)
                       // }
                    } else if let exception = task.exception { // Exception
                        self.task = nil
                        callback(self, .exception(exception))
                    } else if task.result != nil { // Success
                        //					guard let downloadOutput = result as? AWSS3TransferManagerDownloadOutput else { }
                        self.downloaded = true
                        callback(self, nil)
                    }
                }
                
                return nil
            }
        )
    }
}
