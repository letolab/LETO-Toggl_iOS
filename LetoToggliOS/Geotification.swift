//
//  Geotification.swift
//  Geotify
//
//  Created by Ken Toh on 24/1/15.
//  Copyright (c) 2015 Ken Toh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

let kGeotificationLatitudeKey = "latitude"
let kGeotificationLongitudeKey = "longitude"
let kGeotificationRadiusKey = "radius"
let kGeotificationIdentifierKey = "identifier"
let kGeotificationNoteKey = "note"
let kGeotificationEventTypeKey = "eventType"


class Geotification: NSObject, NSCoding, MKAnnotation {
  var coordinate: CLLocationCoordinate2D
  var radius: CLLocationDistance
  var identifier: String
  var note: String

  var title: String? {
    if note.isEmpty {
      return "No Note"
    }
    return note
  }

  
  init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String, note: String) {
    self.coordinate = coordinate
    self.radius = radius
    self.identifier = identifier
    self.note = note
  }

  // MARK: NSCoding

  required init?(coder decoder: NSCoder) {
    let latitude = decoder.decodeDoubleForKey(kGeotificationLatitudeKey)
    let longitude = decoder.decodeDoubleForKey(kGeotificationLongitudeKey)
    coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    radius = decoder.decodeDoubleForKey(kGeotificationRadiusKey)
    identifier = decoder.decodeObjectForKey(kGeotificationIdentifierKey) as! String
    note = decoder.decodeObjectForKey(kGeotificationNoteKey) as! String
  }

  func encodeWithCoder(coder: NSCoder) {
    coder.encodeDouble(coordinate.latitude, forKey: kGeotificationLatitudeKey)
    coder.encodeDouble(coordinate.longitude, forKey: kGeotificationLongitudeKey)
    coder.encodeDouble(radius, forKey: kGeotificationRadiusKey)
    coder.encodeObject(identifier, forKey: kGeotificationIdentifierKey)
    coder.encodeObject(note, forKey: kGeotificationNoteKey)
  }
}
