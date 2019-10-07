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

//New view for the detail info of the list
//To Define a new variable it requieres to change the navigationlink method in the original view
//The way it takes parameters is by defining new variables like "user_selected"
struct DetailView: View{
    //Contains the complete object of the selected User of Core Data from the original view
    var user_selected = User()
    
    var body: some View{
        VStack{
            //Displaying all information of the user selected
            //If it doesnt have the atribute, it displays "Uknown"
            Text("\(user_selected.name ?? "Uknown")")
            Text("\(user_selected.visits) visits")
            Text("\(user_selected.gender ?? "Uknown")")
            Text("Age: \(user_selected.age)")
            Text("Emotion: \(user_selected.emotion ?? "Uknown")")
            Text("Race: \(user_selected.race ?? "Uknown")")
        }//.navigationBarTitle(Text("\(user_selected.name ?? "Uknown")"))
    }
}

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
                        //NavigationLink to let the view know that each prototype label is a different view
                        //We send the complete selected user to the detail view
                        NavigationLink(destination: DetailView(user_selected: list_user))
                        {
                            //Information that displays in the original view
                            VStack{
                                //If it doesnt have the atribute, it displays "Uknown"
                                Text(list_user.name ?? "Unknown").font(.headline)
                                Text("\(list_user.age)").font(.subheadline)
                            }
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
