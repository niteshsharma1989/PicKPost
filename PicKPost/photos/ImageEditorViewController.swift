//
//  ImageEditorViewController.swift
//  PicKPost
//
//  Created by IBAdmin on 15/11/17.
//  Copyright © 2017 Infobeans. All rights reserved.
//https://developer.apple.com/library/content/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIWhitePointAdjust



import UIKit
import Photos

class ImageEditorViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return editCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "edit_cat_cell", for: indexPath) as! PhotoEditorCellCollectionViewCell
        let nameOfCategory = editCategories[indexPath.row]
        cell.filterNameLabel.text = nameOfCategory
        return cell
    }
    
    func registerAllNibsInCollectionView()
    {
        let nibName = UINib(nibName: "PhotoEditorCellCollectionViewCell", bundle:nil)
        editCategoryCollectionView.register(nibName, forCellWithReuseIdentifier: "edit_cat_cell")
        
        
    }
    
    @IBOutlet weak var editCategoryCollectionView: UICollectionView!
    var originalImage = UIImage( named : "facebook_photos")
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var bottomScrollView: UIScrollView!
    
    var currentPhassets : PHAsset?
    var currentUIImage : UIImage?
    
    @IBOutlet weak var imageCroperOverlayView: AKImageCropperView!
     private var cropViewProgrammatically: AKImageCropperView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    var effectButtonList : [UIButton] = []
    
    @IBOutlet weak var filterSelectedIdicator: UIView!
    
    @IBOutlet weak var bightnesSelectorIndicator: UIView!
    @IBOutlet weak var cropSelectedIndicator: UIView!
    
    var contrastFilter: CIFilter!;
    var brightnessFilter: CIFilter!;
    
    var context = CIContext();
     var aCIImage = CIImage();
     var outputImage = CIImage();
    private var cropView : AKImageCropperView {
        return cropViewProgrammatically ?? imageCroperOverlayView as! AKImageCropperView
    }
    
    
    @IBOutlet weak var birghtnessMenuView: UIView!
    @IBOutlet weak var cropMenuImageView: UIView!
    @IBOutlet weak var effectsMenuView: UIView!
    
    var editCategories = [ "Filter", "Blur"]
    
    @IBAction func onBIghtnessChange(_ sender: Any)
    {
        
        brightnessFilter.setValue(NSNumber(value: (sender as! UISlider).value), forKey: "inputBrightness");
        outputImage = brightnessFilter.outputImage!;
        let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
        let newUIImage = UIImage(cgImage: imageRef!)
        self.imageView.image = newUIImage;
    }
    
    @IBAction func onContrastChange(_ sender: Any)
    {
        contrastFilter.setValue(NSNumber(value: (sender as! UISlider).value), forKey: "inputContrast")
       outputImage = contrastFilter.outputImage!;
        var cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        let newUIImage = UIImage(cgImage: cgimg!)
        self.imageView.image = newUIImage;
    }
    
    @IBOutlet weak var bightnessSlider: UISlider!
    @IBOutlet weak var contrast_slider: UISlider!
    @IBAction func onClickResetButton(_ sender: Any)
    {
        
        self.contrast_slider.value = 1
        self.bightnessSlider.value = 0
        
        brightnessFilter.setValue(NSNumber(value: 0), forKey: "inputBrightness");
        outputImage = brightnessFilter.outputImage!;
        let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
        let newUIImage = UIImage(cgImage: imageRef!)
        self.imageView.image = newUIImage;
        
        contrastFilter.setValue(NSNumber(value: 1), forKey: "inputContrast")
        outputImage = contrastFilter.outputImage!;
        var cgimg = context.createCGImage(outputImage, from: outputImage.extent)
        let newUIImagex = UIImage(cgImage: cgimg!)
        self.imageView.image = newUIImagex;
    }
    
    @IBAction func onSelectBrightnessOption(_ sender: Any)
    {
        handleBrightnessVisisblity()
    }
    
   // @IBAction func onSelectRotateOption(_ sender: Any)
    //{
      //  handleRotateVisisblity()
    //}
    
    
    var ciFilterNames =
        [
            "CIPhotoEffectChrome",
            "CIPhotoEffectFade",
            "CIPhotoEffectInstant",
            "CIPhotoEffectNoir",
            "CIPhotoEffectProcess",
            "CIPhotoEffectTonal",
            "CIPhotoEffectTransfer",
            "CISepiaTone",
            "CIColorInvert",
            "CIColorMonochrome",
            "CIColorPosterize",
            "CIFalseColor",
            "CIVignetteEffect",
            "CIMaximumComponent",
            "CIMinimumComponent"
        ]
    
    var xCoord: CGFloat = 5
    let yCoord: CGFloat = 5
    let buttonWidth:CGFloat = 80
    let buttonHeight: CGFloat = 80
    let gapBetweenButtons: CGFloat = 12
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Image Editor"
        handleEffctsVisisblity()
        updateStillImage()
        updateFilterMenu()
    }
    
    func initBrightnessFilter()
    {
        let aUIImage = self.imageView.image;
        let aCGImage = aUIImage?.cgImage;
        aCIImage = CIImage(cgImage: aCGImage!)
        context = CIContext(options: nil);
        contrastFilter = CIFilter(name: "CIColorControls");
        contrastFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter = CIFilter(name: "CIColorControls");
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
    }
    
    var currentIndicatorView : UIView?
    
    func handleInitialIndicator()
    {
        self.currentIndicatorView = self.filterSelectedIdicator
        self.filterSelectedIdicator.isHidden = false
        self.cropSelectedIndicator.isHidden = true
       // self.rotationSelectedIndicator.isHidden = true
        self.bightnesSelectorIndicator.isHidden = true
    }
    
    func handleEffctsVisisblity()
    {
        self.imageView.isHidden = false
        self.effectsMenuView.isHidden = false
        self.cropMenuImageView.isHidden = true
        self.imageCroperOverlayView.isHidden = true
        self.birghtnessMenuView.isHidden = true
        
        self.currentIndicatorView = self.filterSelectedIdicator
        self.filterSelectedIdicator.isHidden = false
        self.cropSelectedIndicator.isHidden = true
    //    self.rotationSelectedIndicator.isHidden = true
        self.bightnesSelectorIndicator.isHidden = true
        
     //   rotateMenuView.isHidden = true
      //  rotateButtonContainer.isHidden = true
    }
    
    func handleCropVisisblity()
    {
        self.imageView.isHidden = true
        self.effectsMenuView.isHidden = true
        self.cropMenuImageView.isHidden = false
        self.imageCroperOverlayView.isHidden = false
        self.birghtnessMenuView.isHidden = true
        
        self.currentIndicatorView = self.cropSelectedIndicator
        self.filterSelectedIdicator.isHidden = true
        self.cropSelectedIndicator.isHidden = false
     //   self.rotationSelectedIndicator.isHidden = true
        self.bightnesSelectorIndicator.isHidden = true
        
        
     //   rotateMenuView.isHidden = true
       // rotateButtonContainer.isHidden = true
    }
    
    func handleBrightnessVisisblity()
    {
        self.imageView.isHidden = false
        self.effectsMenuView.isHidden = true
        self.cropMenuImageView.isHidden = true
        self.imageCroperOverlayView.isHidden = true
        self.birghtnessMenuView.isHidden = false
        
        self.currentIndicatorView = self.filterSelectedIdicator
        self.filterSelectedIdicator.isHidden = true
        self.cropSelectedIndicator.isHidden = true
  //      self.rotationSelectedIndicator.isHidden = true
        self.bightnesSelectorIndicator.isHidden = false
        
        
  //     rotateMenuView.isHidden = true
   //    rotateButtonContainer.isHidden = true
    }
    func handleRotateVisisblity()
    {
        
        
        self.imageView.isHidden = false
        self.effectsMenuView.isHidden = true
        self.cropMenuImageView.isHidden = true
        self.imageCroperOverlayView.isHidden = true
        self.birghtnessMenuView.isHidden = true
        
        self.currentIndicatorView = self.filterSelectedIdicator
        self.filterSelectedIdicator.isHidden = true
        self.cropSelectedIndicator.isHidden = true
     //   self.rotationSelectedIndicator.isHidden = false
        self.bightnesSelectorIndicator.isHidden = true
        
        
     //   rotateMenuView.isHidden = false
     //   rotateButtonContainer.isHidden = true
    }
    
    @IBAction func onClickEnableCropping(_ sender: Any)
    {
        if cropView.isOverlayViewActive 
        {
            
            cropView.showOverlayView(animationDuration: 0.3)
            
           
            
        } else {
            
            cropView.showOverlayView(animationDuration: 0.3)
            
           
            
        }
        handleCropVisisblity()
    }
    
    @IBAction func onClickEnableFilter(_ sender: Any)
    {
        cropView.hideOverlayView(animationDuration: 0)
        handleEffctsVisisblity()
        
        let imageView = self.imageView.image!
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            self.updateCroppedFilterMenu(uiImage: imageView)
            DispatchQueue.main.async { // 2
               // self.fadeInNewImage(overlayImage) // 3
            }
        }
        
        
    
        
    }
    
    
    
   // @IBOutlet weak var rotateButtonContainer: UIView!
    
   // @IBOutlet weak var rotateMenuView: UIView!
    
    @IBOutlet weak var onClickEnableFilter: UIButton!
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: imageView.bounds.width * scale,
                      height: imageView.bounds.height * scale)
    }
    
    @IBOutlet weak var onClickResetAngle: UIButton!
    
    @IBAction func onClickResetAngleOfImage(_ sender: Any)
    {
        
    }
    
    
     func onStartRotatingAngle(_ sender: Any)
    {
        self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat((sender as! UISlider).value * 1 * Float(M_PI) / (sender as! UISlider).maximumValue));
        
    }
    
    func updateFilterMenu()
    {
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        options.progressHandler = { progress, _, _, _ in
            // Handler might not be called on the main queue, so re-dispatch for UI work.
            
        }
        
        
        if self.currentPhassets != nil
        {
            let sizeX = CGSize(width: self.buttonWidth,
                               height: self.buttonHeight)
            
            
            PHImageManager.default().requestImage(for: self.currentPhassets!,
                                                  targetSize: sizeX,
                                                  contentMode: .aspectFit,
                                                  options: options,
                                                  resultHandler: { image, _ in
                                                    
                                                    guard let image = image else { return }
                                                    
                                                    
                                                    //  self.currentImage = image
                                                    var itemCount = 0
                                                    for i in 0...self.ciFilterNames.count - 1
                                                    {
                                                        itemCount = i
                                                        // Button properties
                                                        let filterButton = UIButton(type: .custom)
                                                        filterButton.frame = CGRect(x : self.xCoord, y : self.yCoord, width : self.buttonWidth, height :  self.buttonHeight)
                                                        filterButton.tag = itemCount
                                                        filterButton.addTarget(self, action: #selector(self.filterButtonTapped(_:)), for: .touchUpInside)
                                                        filterButton.layer.cornerRadius = 6
                                                        filterButton.clipsToBounds = true
                                                        
                                                        let ciContext = CIContext(options: nil)
                                                        let coreImage = CIImage(image: image)
                                                        let filter = CIFilter(name: "\(self.ciFilterNames[i])" )
                                                        filter!.setDefaults()
                                                        filter!.setValue(coreImage, forKey: kCIInputImageKey)
                                                        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
                                                        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
                                                        let imageForButton = UIImage( cgImage: filteredImageRef!);
                                                        filterButton.setBackgroundImage(imageForButton, for: .normal)
                                                        self.xCoord +=  self.buttonWidth + self.gapBetweenButtons
                                                        self.bottomScrollView.addSubview(filterButton)
                                                        
                                                        self.effectButtonList.append(filterButton)
                                                        
                                                    }
                                                    
                                                    self.bottomScrollView.contentSize = CGSize( width : self.buttonWidth * CGFloat(self.ciFilterNames.count+2), height : self.yCoord)
                                                    
            })
        }
        else if self.currentUIImage != nil
        {
            
            print("Current IMage is not nil")
            
            var itemCount = 0
            for i in 0...self.ciFilterNames.count - 1
            {
                itemCount = i
                // Button properties
                let filterButton = UIButton(type: .custom)
                filterButton.frame = CGRect(x : self.xCoord, y : self.yCoord, width : self.buttonWidth, height :  self.buttonHeight)
                filterButton.tag = itemCount
                filterButton.addTarget(self, action: #selector(self.filterButtonTapped(_:)), for: .touchUpInside)
                filterButton.layer.cornerRadius = 6
                filterButton.clipsToBounds = true
                
                let ciContext = CIContext(options: nil)
                let coreImage = CIImage(image: self.currentUIImage!)
                let filter = CIFilter(name: "\(self.ciFilterNames[i])" )
                filter!.setDefaults()
                filter!.setValue(coreImage, forKey: kCIInputImageKey)
                let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
                let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
                let imageForButton = UIImage( cgImage: filteredImageRef!);
                filterButton.setBackgroundImage(imageForButton, for: .normal)
                self.xCoord +=  self.buttonWidth + self.gapBetweenButtons
                self.bottomScrollView.addSubview(filterButton)
                
                self.effectButtonList.append(filterButton)
                
            }
            
            self.bottomScrollView.contentSize = CGSize( width : self.buttonWidth * CGFloat(self.ciFilterNames.count+2), height : self.yCoord)
        }
        
        
        
        
        
    }
    
    func updateStillImage()
    {
        
        if self.currentPhassets != nil
        {
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.isNetworkAccessAllowed = true
            options.progressHandler = { progress, _, _, _ in
                // Handler might not be called on the main queue, so re-dispatch for UI work.
                
            }
            
            
            PHImageManager.default().requestImage(for: self.currentPhassets!,
                                                  targetSize: targetSize,
                                                  contentMode: .aspectFit,
                                                  options: options,
                                                  resultHandler: { image, _ in
                                                    
                                                    guard let image = image else { return }
                                                    self.imageView.image = image
                                                    self.originalImage = image
                                                    self.initBrightnessFilter()
                                                    
                                                    self.cropView.delegate = self
                                                    self.cropView.image  = image
                                                    
            })
        }
        else if self.currentUIImage != nil
        {
            self.imageView.image = self.currentUIImage
            self.originalImage = self.currentUIImage
            self.initBrightnessFilter()
            
            self.cropView.delegate = self
            self.cropView.image  = self.currentUIImage
        }
        
        
        
    }
    @objc func filterButtonTapped(_ sender: UIButton)
    {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: self.originalImage!)
        let button = sender as UIButton
        let position = button.tag
        let filterSelected = self.ciFilterNames[position]
        let filter = CIFilter(name: "\(filterSelected)" )
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        let imageForButton = UIImage( cgImage: filteredImageRef!);
        self.imageView.image = imageForButton
          self.imageCroperOverlayView.image  = imageForButton
        
       
        
        
    }
    
    
    
    
    
    
    func updateCroppedFilterMenu( uiImage : UIImage)
    {
        var itemCount = 0
        for i in 0...self.ciFilterNames.count - 1
        {
            itemCount = i
            // Button properties
            
            
            let ciContext = CIContext(options: nil)
            let coreImage = CIImage(image: uiImage)
            DispatchQueue.main.async { // 2
                // self.fadeInNewImage(overlayImage) // 3
            }
            let filter = CIFilter(name: "\(self.ciFilterNames[i])" )
            filter!.setDefaults()
            filter!.setValue(coreImage, forKey: kCIInputImageKey)
            let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
            let imageForButton = UIImage( cgImage: filteredImageRef!);
            
            self.xCoord +=  self.buttonWidth + self.gapBetweenButtons
            
            DispatchQueue.main.async { // 2
                // self.fadeInNewImage(overlayImage) // 3
                 self.effectButtonList[i].setBackgroundImage(imageForButton, for: .normal)
                
                 //self.bottomScrollView.contentSize = CGSize( width : self.buttonWidth * CGFloat(self.ciFilterNames.count+2), height : self.yCoord)
            }
        }
    }
    
    @IBAction func onClickSave(_ sender: Any)
    {
        
        saveImageDocumentDirectory(self.imageView.image!)
    }
    
    @IBOutlet weak var onClickCancelIamgeEditing: UIButton!
    
    @IBAction func onClickCancelButton(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Pic'K Post", message: "All changes will be discard", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            self.imageView.image = self.originalImage
            let imageX = self.imageView.image
            DispatchQueue.global(qos: .userInitiated).async { // 1
                self.updateCroppedFilterMenu(uiImage: imageX!)
             
            }
            self.handleEffctsVisisblity()
            
           
            
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)
    }
    
    
    func saveImage(image: UIImage) -> String {
        
        let imageData = NSData(data: UIImagePNGRepresentation(image)!)
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,  FileManager.SearchPathDomainMask.userDomainMask, true)
        let docs = paths[0] as NSString
        let uuid = "Pick_Post"+NSUUID().uuidString + ".png"
        let fullPath = docs.appendingPathComponent(uuid)
        print(fullPath)
        _ = imageData.write(toFile: fullPath, atomically: true)
        print("=============== \(uuid)")
        
        return uuid
        
    }
    
    func saveImageDocumentDirectory(_ uiImage : UIImage) -> Bool
    {
        
      UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil);
        
        let alertController = UIAlertController(title: "Pic'K Post", message: "Image Saved Successfully", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            
            if let navController = self.navigationController {
                navController.popViewController(animated: true)
            }
            
            
            
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true)
       
        return false
        
       
        
 
    }
    
    
    
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func initCell()
    {
        editCategoryCollectionView.dataSource = self
        editCategoryCollectionView.delegate = self
          registerAllNibsInCollectionView()
        let itemHeightx = editCategoryCollectionView.bounds.height
        print(itemHeightx)
        // let _: CGFloat = max(floor(viewWidth / desiredItemWidth), 2)
        // let padding: CGFloat = 1
        // let itemWidth = floor((viewWidth - (columns - 1) * padding) / columns)
        let itemSize = CGSize(width: itemHeightx, height: itemHeightx)
        
        
        // thumbnailSize = itemSize
        
        if let layout = editCategoryCollectionView!.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = itemSize
            layout.minimumInteritemSpacing = 1
            
            layout.minimumLineSpacing = 1
            layout.scrollDirection = .horizontal
        }
    }
    
   
    
    @IBAction func onClickImageCroppingReset(_ sender: Any)
    {
        cropView.reset(animationDuration: 0.3)
        angle = 0.0
    }
    
    @IBAction func onClickImageCroppingDone(_ sender: Any)
    {
        guard let image = cropView.croppedImage else {
            return
        }
        self.imageView.image  = image
        handleEffctsVisisblity()
      //  self.updateCroppedFilterMenu()
        let imageView = self.imageView.image!
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            self.updateCroppedFilterMenu(uiImage: imageView)
            DispatchQueue.main.async { // 2
                // self.fadeInNewImage(overlayImage) // 3
            }
        }
        
        
      
    }
    
    var angle: Double = 0.0
    
    @IBAction func onClickRotateButton(_ sender: Any)
    {
        angle += M_PI_2
        print("angle \(angle) \(M_PI_2)")
        
        self.cropView.rotate(angle, withDuration: 0.3, completion: { _ in
            
            if self.angle == 2 * M_PI {
                self.angle = 0.0
            }
        })
    }
    
 
}
extension ImageEditorViewController: AKImageCropperViewDelegate {
    
    func imageCropperViewDidChangeCropRect(view: AKImageCropperView, cropRect rect: CGRect) {
        //        print("New crop rectangle: \(rect)")
    }
    
}
