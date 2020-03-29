//
//  Artwork.swift
//  GroupTableViewApp
//
//  Created by Aidan O'Brien on 3/22/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//
import Foundation
import MapKit

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  let discipline: String
  let coordinate: CLLocationCoordinate2D
  
  init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate
    
    super.init()
  }
  
  var subtitle: String? {
    return locationName
  }
}
