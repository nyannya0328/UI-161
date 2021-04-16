//
//  CardHome.swift
//  UI-161
//
//  Created by にゃんにゃん丸 on 2021/04/15.
//

import SwiftUI

var gra = LinearGradient(gradient: .init(colors: [.red,.green,.purple]), startPoint: .bottom, endPoint: .top)

struct CardHome: View {
    
    @State var startAnimation = false
    @State var cardRotation = false
    @State var selectedCard : Card = Card(cardHolder: "", cardNumber: "", cardImage: "", cardValidty: "")
    
    @State var cardAnimation = false
    @Namespace var animaiton
    
    @Environment(\.colorScheme) var scheme
    var body: some View {
        NavigationView{
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack{
                    
                    HStack(spacing:15){
                        
                        
                        
                        NavigationLink(
                            destination: MapView(),
                            label: {
                                
                                Image(systemName: "line.horizontal.3")
                                    .font(.title)
                                    .foregroundColor(.black)
                               
                            })
                       
                            
                      
                        
                        Text("Welcom Back")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        NavigationLink(destination: Home()) {
                            
                            Image("p1")
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 50, height: 50)
                             .clipShape(Circle())
                            
                        }
                       
                           
                               
                       
                        
                        
                    }
                    
                    ZStack{
                        
                        ForEach(cards.indices.reversed(),id:\.self){index in
                            
                            CardView(card: cards[index])
                            
                                .scaleEffect(selectedCard.id == cards[index].id ?  1 : index == 0 ? 1 : 0.9)
                                
                                
                                .rotationEffect(.init(degrees:startAnimation ? 0 : index == 1 ? -15 : (index == 2 ? 15 : 0)))
                                
                                .onTapGesture {
                                   animationView(card: cards[index])
                                }
                            
                            
                                .offset(y:startAnimation ? 0 : index == 1 ? 90 : (index == 2 ? -90 : 0))
                                
                                .matchedGeometryEffect(id: "ANIMATION_VIEW", in: animaiton)
                                
                                .rotationEffect(.init(degrees:selectedCard.id == cards[index].id && cardRotation ? -90 : 0))
                               
                                
                            
                                .zIndex(selectedCard.id == cards[index].id ? 1000 : 0)
                            
                                .opacity(startAnimation ? selectedCard.id == cards[index].id ? 1 : 0 : 1)
                                
                            
                        }
                        
                    }
                    .scaleEffect(0.8)
                    .rotationEffect(.init(degrees: 90))
                    .frame(height: getRect().width - 30)
                    .padding(.top,20)
                    VStack(alignment: .leading, spacing: 15, content: {
                        
                        
                        Text("Total Amount")
                            .font(.callout)
                            .fontWeight(.bold)
                           
                        
                        Text("1.500,500")
                            .font(.title2)
                            .fontWeight(.semibold)
                            
                        
                    })
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity,alignment: .leading)
                    
                    
                    
                }
                .padding()
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(gra.ignoresSafeArea())
            .blur(radius: cardAnimation ? 100 : 0)
            .overlay(
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
                    
                    
                    if cardAnimation{
                        
                        
                        Button(action: {
                            
                            withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.7, blendDuration: 0.5)){
                                
                                
                                startAnimation = false
                                selectedCard = Card(cardHolder: "", cardNumber: "", cardImage: "", cardValidty: "")
                                cardAnimation = false
                                cardRotation = false
                                
                            }
                            
                            
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(scheme != .dark ? .white : .black)
                                .padding(10)
                                .background(Color.primary)
                                .clipShape(Circle())
                        })
                        .padding()
                        
                        CardView(card:selectedCard)
                            .matchedGeometryEffect(id: "ANIMATION_VIEW", in: animaiton)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        
                        
                    }
                    
                })
            
            )
            
            .navigationBarHidden(true)
        }
        
        
        
    }
    
    
    func animationView(card : Card){
        
        selectedCard = card
        
        
        
        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)){
            
            startAnimation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            cardRotation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.spring()){
                
                cardAnimation = true
            }
        }
    }
}

struct CardHome_Previews: PreviewProvider {
    static var previews: some View {
        CardHome()
    }
}

extension View{
    
    
    func getRect()->CGRect{
        
        return UIScreen.main.bounds
    }
    
    func getSafeArea() -> UIEdgeInsets{
        
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}


struct CardView : View {
    var card : Card
    var body: some View{
        Image(card.cardImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(20)
            .overlay(
            
                VStack(alignment: .leading, spacing: 15, content: {
                    Spacer()
                    
                    Text(card.cardNumber)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.pink)
                    
                    Spacer()
                    HStack{
                        
                        
                        VStack(alignment: .leading, spacing: 15, content: {
                            Text("Card Holder")
                                .fontWeight(.bold)
                            
                            Text(card.cardHolder)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            
                            
                        })
                        .foregroundColor(.purple)
                        
                        Spacer(minLength: 10)
                        
                        VStack(alignment: .leading, spacing: 15, content: {
                            Text("Card VaildID")
                                .fontWeight(.bold)
                            
                            Text(card.cardValidty)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            
                            
                        })
                        .foregroundColor(.blue)
                        
                        
                        
                        
                    }
                    
                    
                    
                })
                .padding()
            
            )
        
    }
}
