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

class RepoFile: NSObject, Mappable {
    var name: String?
    var type: String?
    var path: String?
    var downloadURLString: String?
    var htmlURLString: String?
    var apiURLString: String?
    
    required init?(map: Map) {
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: RepoFileNameKey) as? String,
            let type = aDecoder.decodeObject(forKey: RepoFileTypeKey) as? String,
            let path = aDecoder.decodeObject(forKey: RepoFilePathKey) as? String,
            let downloadURLString = aDecoder.decodeObject(forKey: RepoFileDownloadURLKey) as? String,
            let htmlURLString = aDecoder.decodeObject(forKey: RepoFileHTMLURLKey) as? String,
            let apiURLString = aDecoder.decodeObject(forKey: RepoFileAPIURLKey) as? String
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
    

    

}

extension RepoFile: NSCoding {

    override func isEqual(_ object: Any?) -> Bool {
        if let anotherRepoFile = object as? RepoFile {
            return self.htmlURLString == anotherRepoFile.htmlURLString
        }
        return false
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: RepoFileNameKey)
        aCoder.encode(type, forKey: RepoFileTypeKey)
        aCoder.encode(path, forKey: RepoFilePathKey)
        aCoder.encode(downloadURLString, forKey: RepoFileDownloadURLKey)
        aCoder.encode(htmlURLString, forKey: RepoFileHTMLURLKey)
        aCoder.encode(apiURLString, forKey: RepoFileAPIURLKey)
    }
    

}
