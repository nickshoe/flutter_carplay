//
//  FCPExtensions.swift
//  flutter_carplay
//
//  Created by Oğuzhan Atalay on 21.08.2021.
//

extension UIImage {
  convenience init?(withURL url: URL) throws {
    let imageData = try Data(contentsOf: url)
    self.init(data: imageData)
  }

  @available(iOS 14.0, *)
  func fromCorrectSource(name: String) -> UIImage {
    if (name.starts(with: "http")) {
      return fromUrl(url: name)
    } else if (name.starts(with: "file://")) {
      return fromFile(path: name)
    }
    return fromFlutterAsset(name: name)
  }

  @available(iOS 14.0, *)
  func fromFlutterAsset(name: String) -> UIImage {
    let key: String? = SwiftFlutterCarplayPlugin.registrar?.lookupKey(forAsset: name)
    let image: UIImage? = UIImage(imageLiteralResourceName: key!)
    return image ?? UIImage(systemName: "questionmark")!
  }

  @available(iOS 14.0, *)
  func fromFile(path: String) -> UIImage {
    let cleanPath = path.replacingOccurrences(of: "file://", with: "")
    let image: UIImage? = UIImage(contentsOfFile: cleanPath)
    return image ?? UIImage(systemName: "questionmark")!
  }

  @available(iOS 14.0, *)
  func fromUrl(url: String) -> UIImage {
      let url = URL(string: url)
      let data = try? Data(contentsOf: url!)
      guard let data = data else {
          return UIImage(systemName: "questionmark")!
      }
      return UIImage(data: data)!
  }
    
  func resizeImageTo(size: CGSize) -> UIImage? {
      UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
      self.draw(in: CGRect(origin: CGPoint.zero, size: size))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      return newImage
    }
}

extension String {
  func match(_ regex: String) -> [[String]] {
    let nsString = self as NSString
    return (try? NSRegularExpression(pattern: regex, options: []))?.matches(in: self, options: [], range: NSMakeRange(0, nsString.length)).map { match in
        (0..<match.numberOfRanges).map { match.range(at: $0).location == NSNotFound ? "" : nsString.substring(with: match.range(at: $0)) }
    } ?? []
  }
}

/*
TODO: remove?

extension CPListItem {
    func setImageUrl(_ url: URL?) {
        guard let imageUrl = url else { return }

        // TODO: refactor - download image from URL
        // https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }

            // TODO: refactor - crop and resize logic
            // https://developer.apple.com/forums/thread/695636
            let cropped = image.cpCropSquareImage
            let resized = cropped.resized(to: CPListItem.maximumImageSize)
            let carPlayImage = resized?.carPlayImage

            guard carPlayImage != nil else { return }

            DispatchQueue.main.async { [weak self] in
                self?.setImage(carPlayImage)
            }
        }.resume()
    }
}
*/

/*
TODO: remove?

extension UIImage {
    var carPlayImage: UIImage? {
        guard
            let traits = FlutterCarPlaySceneDelegate.interfaceController?
                .carTraitCollection
        else { return nil }

        let imageAsset = UIImageAsset()
        imageAsset.register(self, with: traits)
        return imageAsset.image(with: traits)
    }

    var cpCropSquareImage: UIImage {
        var x: CGFloat
        var y: CGFloat
        var width: CGFloat
        var height: CGFloat

        if size.height < size.width {
            width = size.height
            height = size.height
            x = (size.width - size.height) / 2
            y = 0
        } else {
            width = size.width
            height = size.width
            x = 0
            y = (size.height - size.width) / 2
        }

        let rect: CGRect = CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )

        // Ensure the rect is within the bounds of the image
        let croppedCGImage = self.cgImage?.cropping(to: rect)

        // If cropping succeeds, return a new UIImage
        if let croppedCGImage = croppedCGImage {
            return UIImage(cgImage: croppedCGImage)
        }

        // Return original image if cropping fails
        return self
    }

    // https://stackoverflow.com/questions/70982018/how-to-resize-and-reshape-uiimage-without-causing-any-distortion/71078857#71078857
    func resized(to newSize: CGSize) -> UIImage? {
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: newSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(
                in: CGRect(
                    origin: .zero,
                    size: newSize
                ))
        }

        return scaledImage
    }
}
*/