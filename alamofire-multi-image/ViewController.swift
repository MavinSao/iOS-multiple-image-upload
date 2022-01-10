//
//  ViewController.swift
//  alamofire-multi-image
//
//  Created by Mavin Sao on 10/1/22.
//

import UIKit
import ImageSlideshow
import BSImagePicker
import Photos
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
    let imagePicker = ImagePickerController()
    var imageDatas:[Data] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        slideshow.setImageInputs([
            ImageSource(image: UIImage(systemName: "camera.fill")!),
        ])
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
          slideshow.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func didTap() {
      slideshow.presentFullScreenController(from: self)
    }

    @IBAction func chooseImage(_ sender: Any) {
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        }, finish: { (assets) in
            // Request the maximum size. If you only need a smaller size make sure to request that instead.
            var imagesS: [ImageSource] = []

            for img_asset in assets{
                img_asset.getImageData { image in
                    imagesS.append(ImageSource(image: image!))
                    self.imageDatas.append( image!.jpegData(compressionQuality: 1.0)!)
                }
            }
            self.slideshow.setImageInputs(imagesS)
            
        })
    }
    
    @IBAction func postImage(_ sender: Any) {
        
//        AF.upload(multipartFormData: { multiform in
//            multiform.append(imageData, withName: "image", fileName: ".jpg", mimeType: "image/jpeg")
//        }, to: "\(baseURL)images")
//        .responseDecodable(of: ImgResponse.self) { response in
//            guard let response = response.value else{
//                completion(.failure(ImageError.NoResponse))
//                return
//            }
//            completion(.success(response.url))
//        }
        
    }
    
    
    
    
}

extension PHAsset {
    func getImageData(completionHandler: @escaping((_ image: UIImage?)->Void)) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
            completionHandler(image)
        })
    }
}
