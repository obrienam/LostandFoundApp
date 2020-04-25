//
//  Artwork.swift
//  GroupTableViewApp
//
//  Created by Aidan O'Brien on 3/22/20.
//  Copyright © 2020 Aidan O'Brien. All rights reserved.
//
import Foundation
import MapKit
import Contacts
class Artwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  let discipline: String
  let coordinate: CLLocationCoordinate2D
  var mapItem: MKMapItem? {
    let location = locationName
    
    let addressDict = [CNPostalAddressStreetKey: location]
    let placemark = MKPlacemark(
      coordinate: coordinate,
      addressDictionary: addressDict)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = title
    return mapItem
  }

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
