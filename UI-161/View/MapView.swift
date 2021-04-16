//
//  MapView.swift
//  UI-161
//
//  Created by にゃんにゃん丸 on 2021/04/15.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var coordinate = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125), latitudinalMeters: 10000, longitudinalMeters: 10000)
    
    @State var filterItems = [
        
        filterItem(title: "東京", check: false),
        filterItem(title: "神奈川", check: false),
        filterItem(title: "大阪", check: false),
        filterItem(title: "神戸", check: false),
        filterItem(title: "横浜", check: false),
        filterItem(title: "北海道", check: false),
        filterItem(title: "沖縄", check: false),
        

    ]
    
    @State var egdes = UIApplication.shared.windows.first?.safeAreaInsets
   
    @State var showFileter = false

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
           
            
            Map(coordinateRegion: $coordinate)
                .ignoresSafeArea()
            
            
            Button(action: {
                
                
                
                withAnimation{
                    
                    showFileter.toggle()
                }
                
            }, label: {
                Image(systemName: "lineweight")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.vertical,10)
                    .padding(.horizontal,10)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(color: Color.primary.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.primary.opacity(0.1), radius: 5, x: -5, y: -5)
            })
            .padding(.trailing)
            .padding(.top,10)
            
            
            VStack{
                
                Spacer()
                
                
                VStack(spacing:20){
                    
                    HStack{
                        
                        Text("Search By")
                            .font(.title2)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        
                        Button(action: {
                            
                            
                            
                            
                        }, label: {
                            Text("Done")
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        })
                    }
                    .padding([.horizontal,.top])
                    .padding(.bottom,10)
                    
                    ForEach(filterItems){filter in
                        
                        CardVie(title: filter)
                     
                        
                    }
                    
                    
                    
                    
                }
               
             .padding(.bottom,10)
                .padding(.bottom,getSafeArea().bottom)
                .padding(.top,10)
                .background(Color.white.clipShape(CustomShape(corner: [.topLeft,.topRight], radi: 20)))
                .offset(y: showFileter ? 0 : getRect().height / 2)
            }
            .ignoresSafeArea()
            .background(Color.black.opacity(0.3).ignoresSafeArea()
            
                            .opacity(showFileter ? 1 : 0)
                            .onTapGesture {
                                withAnimation{
                                    
                                    showFileter.toggle()
                                }
                            }
            
            
            )
            
            
        })
    }
}

struct CustomShape : Shape {
    
    var corner : UIRectCorner
    var radi : CGFloat
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radi, height: radi))
        return Path(path.cgPath)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct filterItem : Identifiable {
    var id = UUID().uuidString
    var title : String
    var check : Bool
}


struct CardVie : View {
    
    @State var title : filterItem
    var body: some View{
        
        HStack{
            
            
            Text(title.title)
                .fontWeight(.semibold)
                .foregroundColor(Color.black.opacity(0.7))
            
            Spacer()
            
            
            ZStack{
                
                
                Circle()
                    .stroke(title.check ? Color.green : Color.green,lineWidth: 3)
                    .frame(width: 28, height: 28)
                
                
                if title.check{
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(.green)
                    
                    
                    
                }
                
            }
            
            
            
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            title.check.toggle()
        })
        
        
    }
}



