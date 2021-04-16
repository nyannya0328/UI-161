//
//  HomeViewModel.swift
//  UI-161
//
//  Created by にゃんにゃん丸 on 2021/04/15.
//

import SwiftUI
import Photos
import AVKit

class HomeViewModel:NSObject,PHPhotoLibraryChangeObserver, ObservableObject {
   
    
    
    @Published var showImagePicker = false
    
    @Published var libray_statas = librayStatas.denied
    
    @Published var fethcPhotos : [Asset] = []
    
    @Published var allPhotos : PHFetchResult<PHAsset>!
    
   
    @Published var shopreview = false
    @Published var selectedImagePreview : UIImage!
    @Published var selectedvideoPreview : AVAsset!
    
    
    
    func extractPreviewData(asset : PHAsset){
        
        let manager = PHCachingImageManager()
        
        if asset.mediaType == .image{
            
            
            getImageFromeAsset(asset: asset, size: PHImageManagerMaximumSize) { (image) in
                DispatchQueue.main.async {
                    self.selectedImagePreview = image
                    
                }
                
            }
           
            
            
        }
        
        if asset.mediaType == .video{
            
            
            let videoManager = PHVideoRequestOptions()
            
            videoManager.deliveryMode = .highQualityFormat
            
            manager.requestAVAsset(forVideo: asset, options: videoManager) { (videoAsset, _, _) in
                
                guard let videoUrl = videoAsset else {return}
                
                DispatchQueue.main.async {
                    self.selectedvideoPreview = videoUrl
                }
            }
            
            
        }
        
        
    }
    
    
    
    
   
    func openImagePicker(){
        
      
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        
        if fethcPhotos.isEmpty{fetchPhotas()}
        
        withAnimation{showImagePicker.toggle()}
        
        
    }
    func setUP(){
        
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) {[self] (statas) in
            
            
            DispatchQueue.main.async {
                switch statas{
                
                case.denied : libray_statas = .denied
                case.authorized : libray_statas = .approved
                case .limited : libray_statas = .limited
                default : libray_statas = .denied
                
                }
            }
           
            
        }
        
        PHPhotoLibrary.shared().register(self)
        
    }
    
    func fetchPhotas(){
        
        let options = PHFetchOptions()
        
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        options.includeHiddenAssets = false
        
        let fethcRequest = PHAsset.fetchAssets(with: options)
        allPhotos = fethcRequest
        
        fethcRequest.enumerateObjects {[self] (asset, index, _) in
            
            getImageFromeAsset(asset: asset, size: CGSize(width: 150, height: 150)) { (image) in
                
                fethcPhotos.append(Asset(asset: asset, image: image))
                
            }
            
        }
    }
    
    func getImageFromeAsset(asset:PHAsset,size:CGSize,competition:@escaping(UIImage) -> ()){
        
        let imageManager = PHCachingImageManager()
        imageManager.allowsCachingHighQualityImages = true
        
        let imageOptions = PHImageRequestOptions()
        imageOptions.deliveryMode = .highQualityFormat
        imageOptions.isSynchronous = false
        
        let size = CGSize(width: 150, height: 150)
        
        imageManager.requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: PHImageRequestOptions()) { (image, _) in
            
            guard let resizedimage = image else{return}
            competition(resizedimage)
            
        }
        
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let _ = allPhotos else{return}
        
        if let allUpdates = changeInstance.changeDetails(for: allPhotos){
            
            let updatedPhoto = allUpdates.fetchResultAfterChanges
            
            updatedPhoto.enumerateObjects { [self](asset, index, _) in
                if !allPhotos.contains(asset){
                    
                    getImageFromeAsset(asset: asset, size: CGSize(width: 150, height: 150)) { (image) in
                        
                        DispatchQueue.main.async {
                            
                            fethcPhotos.append(Asset(asset: asset, image: image))
                            
                        }
                    }
                    
                    
                }
                
            }
            
            allPhotos.enumerateObjects { (asset, index, _) in
                
               
                
                if !updatedPhoto.contains(asset){
                    
                    DispatchQueue.main.async {
                        
                        self.fethcPhotos.removeAll { (result) -> Bool in
                            
                            return result.asset == asset
                            
                        }
                        
                    }
                    
                }
                
            }
            
            DispatchQueue.main.async {
                self.allPhotos = updatedPhoto
            }
            
            
        }
        
    }
    
    
    
    
    
}

