//
//  RepoFile.swift
//  CodeReader
//
//  Created by vulgur on 16/5/27.
//  Copyright © 2016年 MAD. All rights reserved.
//

import ObjectMapper

let RepoFileNameKey = "repo_file_name"
let RepoFileTypeKey = "repo_file_type"
let RepoFilePathKey = "repo_file_path"
let RepoFileDownloadURLKey = "repo_file_download_url"
let RepoFileHTMLURLKey = "repo_file_html_url"
let RepoFileAPIURLKey = "repo_file_api_url"

class RepoFile: NSObject, NSCoding, Mappable {
    var name: String?
    var type: String?
    var path: String?
    var downloadURLString: String?
    var htmlURLString: String?
    var apiURLString: String?
    
    required init?(_ map: Map) {
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObjectForKey(RepoFileNameKey) as? String,
             let type = aDecoder.decodeObjectForKey(RepoFileTypeKey) as? String,
             let path = aDecoder.decodeObjectForKey(RepoFilePathKey) as? String,
             let downloadURLString = aDecoder.decodeObjectForKey(RepoFileDownloadURLKey) as? String,
             let htmlURLString = aDecoder.decodeObjectForKey(RepoFileHTMLURLKey) as? String,
             let apiURLString = aDecoder.decodeObjectForKey(RepoFileAPIURLKey) as? String
            else {
                return nil
            }
        self.name = name
        self.type = type
        self.path = path
        self.downloadURLString = downloadURLString
        self.htmlURLString = htmlURLString
        self.apiURLString = apiURLString
    }
    
    func mapping(map: Map) {
        name                <- map["name"]
        type                <- map["type"]
        path                <- map["path"]
        downloadURLString   <- map["download_url"]
        htmlURLString       <- map["html_url"]
        apiURLString        <- map["url"]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: RepoFileNameKey)
        aCoder.encodeObject(type, forKey: RepoFileTypeKey)
        aCoder.encodeObject(path, forKey: RepoFilePathKey)
        aCoder.encodeObject(downloadURLString, forKey: RepoFileDownloadURLKey)
        aCoder.encodeObject(htmlURLString, forKey: RepoFileHTMLURLKey)
        aCoder.encodeObject(apiURLString, forKey: RepoFileAPIURLKey)
    }
}
