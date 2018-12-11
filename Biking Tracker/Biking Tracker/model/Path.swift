//
//  path.swift
//  Biking Tracker
//
//  Created by Soheil on 12/10/18.
//  Copyright © 2018 sohe1l. All rights reserved.
//

import Foundation
import MapKit


class Path: NSObject, Codable{
    
    var title: String
    var lats: [Double] = []
    var lngs: [Double] = []
    
    override init(){
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy-MM-dd HH:mm"
        let date = Date()
        self.title = dateFormatter.string(from: date)
        print(self.title)
        
        super.init()
    }
    
    init(title: String){
        self.title = title
    }

}
