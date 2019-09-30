//
//  HistorialView.swift
//  realtime_crowd_insights
//
//  Created by Mickey Rocha on 9/28/19.
//  Copyright © 2019 Miguel Bazán. All rights reserved.
//

/*
 Source: https://www.hackingwithswift.com/quick-start/swiftui/
 */

import SwiftUI
import CoreData

struct HistorialView: View {
    
    //To create a new Core Data object, we need to add an @Environment property so we can be in the same context
    @Environment(\.managedObjectContext) var contextData
    
    //To fetch data from Core Data, we use the "Fetch Request command" and it has to have a sortDescriptor of any key
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \User.name, ascending: true)]) var list_users: FetchedResults<User>
    
    @State private var newUser = ""
        
    var body: some View{
        NavigationView{
            List{
                Section(header: Text("Agregar Usuarios Prueba")){
                    HStack{
                        //Example of Core Data
                        //if self.managedObjectContext.hasChanges {code}
                        TextField("Usuario Prueba", text: self.$newUser)
                        Button(action:{
                            //Creating a Core Data object to save the information
                            let user = User(context: self.contextData)
                            user.name = "\(self.newUser)"
                            user.age = 22
                            user.gender = "Masculino"
                            user.emotion = "Confundido porque cambiaron mucho Swift"
                            user.visits = 10000
                            
                            //Trying to save the data
                            do{
                                try self.contextData.save()
                            }
                            catch{
                                print("Error en el boton: \(error)")
                            }

                            self.newUser = ""
                        }){
                            Image(systemName: "plus.circle.fill").foregroundColor(.green)
                        }
                    }
                }
                
                Section(header: Text("Usuarios")){
                    ForEach(list_users, id: \.self){ list_user in
                        VStack{
                            Text(list_user.name ?? "Unknown").font(.headline)
                            Text("\(list_user.age)").font(.subheadline)
                        }
                    }

                }
            }.navigationBarTitle(Text("Historial"))
        }
    }
}

struct HistorialView_Previews: PreviewProvider {
    static var previews: some View {
        HistorialView()
    }
}
