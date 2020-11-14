//
//  Goods.swift
//  goodstracker
//
//  Created by njuios on 2020/11/14.
//

import UIKit
import os.log
struct PropertyKey{
    static let name = "name"
    static let desc = "desc"
    static let photo = "photo"
}
class Goods:NSObject,NSCoding{
    var name:String
    var desc:String
    var photo:UIImage?
    static let docudir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveurl = docudir.appendingPathComponent("goods")
    init?(name:String,desc:String,photo:UIImage?){
        guard !name.isEmpty else{
            return nil
        }
        self.name = name
        self.desc = desc
        self.photo = photo
    }
    required convenience init?(coder aDecoder:NSCoder){
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else{
            os_log("Unable to decode name")
            return nil
        }
        let desc = aDecoder.decodeObject(forKey: PropertyKey.desc) as! String
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as?UIImage
        self.init(name:name,desc:desc,photo:photo)
    }
    func encode(with coder: NSCoder) {
        coder.encode(name,forKey: PropertyKey.name)
        coder.encode(desc,forKey: PropertyKey.desc)
        coder.encode(photo,forKey: PropertyKey.photo)
    }
}
