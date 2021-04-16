//
//  Home.swift
//  UI-161
//
//  Created by にゃんにゃん丸 on 2021/04/15.
//

import SwiftUI
import AVKit

struct Home: View {
    @State var message = ""
    
    @StateObject var HomeVM = HomeViewModel()
    var body: some View {
        NavigationView{
            
            VStack{
                
                ScrollView{
                    
                    
                    
                }
                
                VStack{
                    HStack{
                        
                        Button(action:
                            
                            HomeVM.openImagePicker
                            
                        ) {
                            Image(systemName:HomeVM.showImagePicker ? "xmark" : "plus")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                        }
                        
                        TextField("New Message", text: $message, onEditingChanged: { (opend) in
                            
                            if opend && HomeVM.showImagePicker{
                                
                                withAnimation{
                                    
                                    HomeVM.showImagePicker.toggle()
                                }
                            }
                            
                        })
                            .padding(.vertical)
                            .padding(.horizontal)
                            .background(Color.primary.opacity(0.06))
                            .clipShape(Capsule())
                        
                        Button(action: {}) {
                            Image(systemName: "camera")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "mic")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                        }
                        
                        
                    
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom,4)
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing:10){
                            ForEach(HomeVM.fethcPhotos){photo in
                                
                            
                                ThumbnailView(photo: photo)
                                    .onTapGesture {
                                        HomeVM.extractPreviewData(asset: photo.asset)
                                        HomeVM.shopreview.toggle()
                                    }
                                
                            }
                            
                            
                            if HomeVM.libray_statas == .denied || HomeVM.libray_statas == .limited{
                                
                                VStack(spacing:10){
                                    
                                   Text(HomeVM.libray_statas == .denied  ?  "Arrow Access For Photo" : "SelectMorePhoto")
                                    .foregroundColor(.gray)
                                    
                                    Button(action: {
                                        
                                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                                        
                                    }) {
                                        
                                        Text(HomeVM.libray_statas == .denied ? "Arrow Access" : "SelectMorePhoto")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                            .padding(.vertical,10)
                                            .padding(.horizontal)
                                            .background(Color.blue)
                                            .cornerRadius(5)
                                        
                                        
                                    }
                                    
                                    
                                }
                                .frame(width: 100)
                                
                                
                            }
                            
                            
                        }
                        .padding()
                        
                        
                        
                    }
                    .frame(height: HomeVM.showImagePicker ? 200 : 0)
                     .background(Color.primary.opacity(0.04).ignoresSafeArea(.all, edges: .bottom))
                    .opacity(HomeVM.showImagePicker ? 1 : 0)
                    
                }
                
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    
                    Button(action: {}) {
                        
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    
                }
                
                
                ToolbarItem(id: "profile", placement: .navigationBarLeading, showsByDefault: true) {
                    
                    HStack(spacing:8){
                        
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 35, height: 35)
                            .overlay(
                            
                            Text("K")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            )
                        
                        Text("KAVSOFT")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .kerning(1.3)
                        
                        
                        Divider()
                            .background(Color.primary)
                        
                        Spacer()
                        
                        Image("p1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                        
                    }
                    
                    
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing ) {
                    
                    
                    Button(action: {}) {
                        
                        Image(systemName: "phone")
                            .font(.title2)
                    }
                    
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    
                    Button(action: {}) {
                        
                        Image(systemName: "camera")
                            .font(.title2)
                    }
                    
                }
                
                
            })
        }
        .accentColor(.purple)
        .navigationBarHidden(true)
        .onAppear(perform: HomeVM.setUP)
        .sheet(isPresented: $HomeVM.shopreview, onDismiss: {
            
            HomeVM.selectedvideoPreview = nil
            HomeVM.selectedImagePreview = nil
            
            
            
        }, content: {
            
            previewView()
                .environmentObject(HomeVM)
            
        })
    }
}

struct previewView : View {
    
    @EnvironmentObject var HomeVM : HomeViewModel
    
    var body: some View{
        
        NavigationView{
            
            ZStack{
                
                
                if HomeVM.selectedvideoPreview != nil{
                    
                    VideoPlayer(player: AVPlayer(playerItem: AVPlayerItem(asset: HomeVM.selectedvideoPreview)))
                    
                    
                }
                
                if HomeVM.selectedImagePreview != nil{
                    
                    Image(uiImage: HomeVM.selectedImagePreview)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {}) {
                        Text("Text Send")
                    }
                    
                }
                
            })
            
            
        }
        
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct ThumbnailView : View {
    
    var photo : Asset
    
    var body: some View{
        
        ZStack(alignment: .bottomTrailing) {
            
            
            
            Image(uiImage: photo.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150
                )
                .cornerRadius(15)
            
            
            if photo.asset.mediaType == .video{
                
                Image(systemName: "video.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(8)
                
                
                
                
            }
            
        }
        

    }

}
