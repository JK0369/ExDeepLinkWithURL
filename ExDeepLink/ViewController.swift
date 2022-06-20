//
//  ViewController.swift
//  ExDeepLink
//
//  Created by Jake.K on 2022/06/20.
//

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let deepLinkURL = "my-app://home/sub?name=jake"
    let deepLink = MyDeepLink(urlString: "my-app://home/sub?name=jake")
    print(deepLink)
  }
}


enum MyDeepLink {
  private static var scheme: String { return "my-app" }
  
  case home(name: String?)
  
  var host: String {
    switch self {
    case .home:
      return "home"
    }
  }

  var path: String {
    switch self {
    case .home:
      return "/sub"
    }
  }

  var queryItems: [URLQueryItem] {
    switch self {
    case let .home(name):
      return [URLQueryItem(name: "name", value: name)]
    }
  }
  
  static func ~= (lhs: Self, rhs: URL) -> Bool {
    lhs.host == rhs.host && lhs.path == rhs.path
  }

  init?(urlString: String) {
    guard
      let url = URL(string: urlString),
      Self.scheme == url.scheme
    else { return nil }
    
    switch url {
    case .home(name: nil):
      self = .home(name: url.getValue("name"))
    default:
      return nil
    }
  }
}

extension URL {
  func getValue(_ key: String) -> String? {
    URLComponents(url: self, resolvingAgainstBaseURL: true)?
      .queryItems?
      .first(where: { $0.name == key })?
      .value
  }
}
