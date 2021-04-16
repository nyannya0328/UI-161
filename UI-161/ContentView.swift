//
//  ContentView.swift
//  UI-161
//
//  Created by にゃんにゃん丸 on 2021/04/15.
//

import SwiftUI

struct ContentView: View {
    
    @State var gotoHome = false
    var body: some View {
        
       
            ZStack{

                if gotoHome{

                    CardHome()

                }

                else{



                    onBoardScreen()

                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("NEXT")), perform: { _ in
                withAnimation{

                    self.gotoHome = true
                }
            })

      
        

      
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct onBoardScreen : View {
    
    @State var offset : CGFloat = 0
    @State var maxHeight = UIScreen.main.bounds.width - 100
    var body: some View{
        
        ZStack{
            
            gra
                .ignoresSafeArea()
            
            VStack(spacing:0){
                
                Text("Smart Learn")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Tiger man")
                    .font(.callout)
                    .foregroundColor(.primary)
                    .padding()
                    .padding(16)
                
                
                Image("p1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 350)
                    .clipShape(Circle())
                  
                
                Spacer(minLength: 0)
                
                
                ZStack{
                    
                    
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                    
                    TextShimer(title: "Swip to start")
                        .offset(x: 15)
                    
                    HStack{
                        
                        Capsule()
                            .fill(Color.red)
                            .frame(width: CaluculateWith() + 55)
                        
                        Spacer()
                    }
                    
                    
                    HStack{
                        
                        
                        ZStack{
                            
                            Image(systemName: "chevron.right")
                            Image(systemName: "chevron.right")
                                .offset(x: -10)
                            
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .offset(x: 5)
                        .frame(width: 65, height: 65)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: offset)
                        .gesture(DragGesture().onChanged(onChanged(value:)).onEnded(onEnd(value:)))
                        
                        Spacer()
                        
                        
                        
                    }
                    
                    
                }
                .frame(width: getRect().width - 100, height: 65)
                .padding(.bottom)
                    
                   
                
                
                
                
            }
        }
    }
    
    func CaluculateWith() -> CGFloat{
        
        let progress = offset / maxHeight
        
        return progress * maxHeight
        
    }
    
    func onChanged(value : DragGesture.Value){
        
        if value.translation.width > 0 && offset <= getRect().width - 160{
            
            
            offset = value.translation.width
        }
        
        
    }
    
    func onEnd(value : DragGesture.Value){
        
        withAnimation(.easeOut(duration: 0.3)){
            
            if offset > 180{
                
                
                offset = getRect().width - 160
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    
                    NotificationCenter.default.post(name: Notification.Name("NEXT"), object: nil)
                    
                }
            }
            
            else{
                
                offset = 0
            }
            
            
            
        }
        
    }
}

struct TextShimer : View {
    @State var AnimationIn = false
    var title : String
    var body: some View{
        
        ZStack{
            
            Text(title)
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing:0){
                
                ForEach(0..<title.count,id:\.self){index in
                    
                    Text(String(title[title.index(title.startIndex,offsetBy: index)]))
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(randomColor())
                    
                    
                }
                
            }
            .mask(
            
            
            Rectangle()
                .fill(
                
                gra
                )
                .rotationEffect(.init(degrees: 70))
                .padding(5)
                .offset(x: -250)
                .offset(x: AnimationIn ? 500 : 0)
            )
            .onAppear(perform: {
                withAnimation(Animation.linear(duration:2).repeatForever(autoreverses: false)){
                    
                    AnimationIn.toggle()
                }
            })
        }
        
    }
    
    func randomColor()->Color{
        
        let color = UIColor.init(displayP3Red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
        return Color(color)
    }
}
